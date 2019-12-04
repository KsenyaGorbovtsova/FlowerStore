//
//  SignInController.swift
//  FitApp
//
//  Created by Gorbovtsova Ksenya on 24/03/2019.
//  Copyright © 2019 Gorbovtsova Ksenya. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class SignIn: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswdTextField: UITextField!
    let spinner = UIActivityIndicatorView(style: .gray)
    @IBAction func SignIn(_ sender: Any) {
        if (self.emailTextField.text?.isEmpty)! || (self.pswdTextField.text?.isEmpty)! {
            DisplayWarnining(warning: "Fill in all the fields", title: "Warning", dismissing: false, sender: self)
            return
        }
        self.spinner.color = UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1)
        self.spinner.center = view.center
        self.spinner.hidesWhenStopped = false
        self.spinner.startAnimating()
        view.addSubview(self.spinner)
        self.login(email: self.emailTextField.text!, password: self.pswdTextField.text!)
    }
    var token = ""
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let sub = Gradient()
        view.layer.insertSublayer(sub.setGradient(view: self.view), at: 0)
        self.emailTextField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.76)
        self.pswdTextField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.76)
        self.signInButton.layer.cornerRadius = 5
        
        
        
    }
    
    private func login (email: String, password: String) {
        if isInternetAvailable() {
        let loginData = String(format: "%@:%@", email, password).data(using: String.Encoding.utf8)!
        let base64 = loginData.base64EncodedString()

        let url = URL(string: "https://peaceful-woodland-66560.herokuapp.com/users/login")
        var request = URLRequest(url: url!)
         request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            self.stopSpinner(spinner: self.spinner)
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let error = json["error"], let reason = json["reason"]  {
                        if error as! Bool == true && reason as! String == "User not authenticated."{
                           DisplayWarnining(warning: "Не верный адрес или пароль", title: "Warning", dismissing: false, sender: self)
                            DispatchQueue.main.async {
                                self.pswdTextField.text = ""
                            }
                        
                        }
                    }
                    else {
                        //self.DisplayWarnining(warning: "Successful login", title: "Congrats" + "🎉", dismissing: true)
                    self.token = json["token"] as! String
                    self.userID = json["userId"] as! String
                        let saveAccessToken: Bool = KeychainWrapper.standard.set(json["token"] as! String, forKey: "accessToken")
                        let saveUserId: Bool = KeychainWrapper.standard.set(json["userId"] as! String, forKey: "userId")
                        
                        if (saveAccessToken == false || saveUserId == false) {
                            DisplayWarnining(warning: "Error, please try again", title: "Warning", dismissing: false, sender: self)
                            self.pswdTextField.text = ""
                            return
                        }
                        DispatchQueue.main.async {
                           
                            let mainPage = self.storyboard?.instantiateViewController(withIdentifier: "mainPageNav") as! UITabBarController
                            let appdelegate = UIApplication.shared.delegate
                            appdelegate?.window??.rootViewController = mainPage
                            self.modalPresentationStyle = .fullScreen
                            self.present(mainPage, animated: true, completion: nil)
                            
                        }
                        
                    
                    print(json)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        }
        
        else {
            DisplayWarnining(warning: "проверьте подключение к интернету", title: "Упс!", dismissing: false, sender: self)
            self.stopSpinner(spinner: spinner)
        }
        
    }
    
    func stopSpinner(spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
  /*  func DisplayWarnining (warning: String, title: String, dismissing: Bool) -> Void {
        DispatchQueue.main.async {
            let warningController = UIAlertController(title: title, message: warning, preferredStyle: .alert)
            
            let buttonAction = UIAlertAction(title: "Got it!", style: .default)
            { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    warningController.dismiss(animated: true, completion: nil)
                    if dismissing == true {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            warningController.addAction(buttonAction)
            self.present(warningController, animated: true, completion: nil)
        }
        
    }*/
}

public class Gradient {
public func setGradient (view: UIView) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
        UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1).cgColor,
        UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1).cgColor,
        UIColor(red: 0, green: 0.48, blue: 1, alpha: 1).cgColor,
        UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: -1, c: 2.17, d: 0, tx: -0.58, ty: 1))
    gradientLayer.frame = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
    gradientLayer.position = view.center
    gradientLayer.locations = [0, 0, 0.54, 1]
    return gradientLayer
}
}
