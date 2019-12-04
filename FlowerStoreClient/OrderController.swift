//
//  OrderController.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 26/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import UIKit
import  SwiftKeychainWrapper
class OrderController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewOrder: UITableView!
    @IBAction func setDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
              datePickerView.datePickerMode = UIDatePicker.Mode.date
        let calendar = Calendar.current
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
        datePickerView.minimumDate = tomorrow
                    sender.inputView = datePickerView
                    datePickerView.addTarget(self, action: #selector(OrderController.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    @IBOutlet weak var setDate: UITextField!
   
    @objc func datePickerValueChanged(sender:UIDatePicker) {
           let dateFormatter = DateFormatter()
           dateFormatter.calendar = Calendar(identifier: .iso8601)
           // formatter.dateFormat = "EEEE, dd MMM yyyy" // для телефона
           dateFormatter.dateFormat = "EEEE, MMM dd, yyyy" // для компа
           /*let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = DateFormatter.Style.full
           dateFormatter.timeStyle = DateFormatter.Style.none*/
           setDate.text = dateFormatter.string(from: sender.date)
            orderDate = sender.date
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cart.dequeueReusableCell(withIdentifier: "itemsInCart", for: indexPath) as! TexttableCell
        cell.configure(text: "", placeholder: "Кол-во")
        let array = Array(itemsInCart)
        let item = array[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    let itemInOrderFinish = ItemOrder()
    func prepareDataForSubbmitting() {
        
        let cells:[TexttableCell] = self.tableViewOrder!.visibleCells as! [TexttableCell]
        for cell in cells {
            let quantity = Int(cell.textField.text ?? "0")
            let item = (cell.textLabel?.text)!
            let idItem = itemsInCart.first(where: {$0.name == item})?.id
            let itemOrderRecord = ItemOrderGateway()
            itemOrderRecord.idItem = idItem
            itemOrderRecord.idOrder = ""
            itemOrderRecord.quantity = quantity
            
            self.itemInOrderFinish.itemOrderData.append(itemOrderRecord)
        }
    }
    let orderFinish = Order()
    func prepareOrder () {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        orderFinish.orderData.paymentType = self.paymetType
        orderFinish.orderData.date = dateFormatter.date(from: "2019-12-20T00:39:57Z")
        orderFinish.orderData.user =  KeychainWrapper.standard.string(forKey: "userId")
        
    }
    @IBOutlet weak var cart: UITableView!
    
    var itemsInCart = Set<ItemGateway>()
    var paymetType = "None"
    var orderDate = Date()
    @IBAction func plasticCardButton(_ sender: UIButton) {
        self.plasticCard.tintColor = .link
         self.plasticCard.titleLabel?.textColor = .link
        self.plasticCard.layer.borderColor = UIColor.link.cgColor
        self.paymetType = "Card"
        self.Cashbutton.tintColor = .lightGray
        self.Cashbutton.titleLabel?.textColor = .lightGray
        self.Cashbutton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var Cashbutton: UIButton!
    @IBOutlet weak var plasticCard: UIButton!
    @IBAction func CashButton(_ sender: UIButton) {
        self.Cashbutton.tintColor = .link
        self.Cashbutton.titleLabel?.textColor = .link
        self.Cashbutton.layer.borderColor = UIColor.link.cgColor
        self.paymetType = "Cash"
        self.plasticCard.tintColor = .lightGray
        self.plasticCard.titleLabel?.textColor = .lightGray
        self.plasticCard.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        cart.dataSource = self
        self.cart.delegate = self
        self.submitButton.layer.cornerRadius = 10
        self.Cashbutton.layer.cornerRadius = 10
        self.plasticCard.layer.cornerRadius = 10
        self.Cashbutton.layer.borderColor = UIColor.link.cgColor
        self.Cashbutton.layer.borderWidth = CGFloat(2)
        self.plasticCard.layer.borderColor = UIColor.link.cgColor
        self.plasticCard.layer.borderWidth = CGFloat(2)
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.async {
                   self.cart.reloadData()
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        self.prepareOrder()
        self.prepareDataForSubbmitting()
        Order().createOrderForUser(orderData: self.orderFinish, itemsInOrder: self.itemInOrderFinish)
        
    }
    
    @objc func setAddedToCartItems(notification: Notification) {
         if let data = notification.userInfo as? [Item:String] {
            for x in data {
                for y in x.key.itemsList{
                    self.itemsInCart.insert(y)
                }
            }
     }
        if let table = self.cart {
        DispatchQueue.main.async {
                         self.cart.reloadData()
              }
        }
      
        
}
}
extension Notification.Name {
    static let addedToCartItems = Notification.Name("addedToCartItems")
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
