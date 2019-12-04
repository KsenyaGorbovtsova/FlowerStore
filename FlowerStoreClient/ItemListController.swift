//
//  ItemsListController.swift
//  FlowerStoreApp
//
//  Created by Gorbovtsova Ksenya on 25/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import UIKit

class ItemsListController: UITableViewController {
    
    
    var listOfItems = Item()
    var addedToCartItems = [Item: String]()
    override func viewDidLoad() {
    super.viewDidLoad()
        self.getCatalog()
          //Вызов функции, реализующей Table Module
        NotificationCenter.default.post(name: .reload, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: .reload, object: nil)
         navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    func getCatalog () {
        self.listOfItems.getItems()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfItems.itemsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item: ItemGateway = self.listOfItems.itemsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllItemsCell", for: indexPath)
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = String(item.price!) + "¥"
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
       override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToCart = UITableViewRowAction(style: .normal, title: "Add to Cart") { (action, indexPath) in
            var added = [ItemGateway]()
            var itemS = Item()
            added.append(self.listOfItems.itemsList[indexPath.row])
            itemS.addToCart(items: added)
            self.addedToCartItems[itemS] = "0"
            
            print (self.addedToCartItems)
            NotificationCenter.default.post(name: .addedToCartItems, object: nil, userInfo: self.addedToCartItems)
        }
        addToCart.backgroundColor = .blue
        return [addToCart]
    }
    
    @objc func reload(notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print(self.listOfItems.itemsList.count)
            print("km")
        }
    }
}

extension Notification.Name{
    static let reload = Notification.Name("reload")
    static let reloadUser = Notification.Name("reloaadUser")
}
