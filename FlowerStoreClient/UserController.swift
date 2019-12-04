//
//  UserController.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 27/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import UIKit

class UserController: ViewController {
    var userData = User()
    
    @IBOutlet weak var surnameTextBox: UITextField!
    @IBOutlet weak var nameTextBox: UITextField!
    override func viewDidLoad() {
    super.viewDidLoad()
         navigationController?.navigationBar.prefersLargeTitles = true
        self.userData.getUserPublicInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUser(notification:)), name: .reloadUser, object: nil)
        NotificationCenter.default.post(name: .reloadUser, object: nil)
        
           
        
        
    }
    
    @objc func reloadUser(notification:Notification) {
           DispatchQueue.main.async {
            self.nameTextBox.text = self.userData.userData.name
            self.surnameTextBox.text = self.userData.userData.surname}
       }
}
