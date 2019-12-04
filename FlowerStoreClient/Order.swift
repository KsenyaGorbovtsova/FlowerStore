//
//  Order.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 28/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
class Order: NSObject {
    
    var orderData: OrderGateway
    
    public override init() {
        self.orderData = OrderGateway()
    }
    func createOrderForUser(orderData:Order,itemsInOrder:ItemOrder){
        OrderGateway().insertRows(orderData: orderData, itemsInOrder: itemsInOrder)
    }
}
    /*func insertRows(orderData: Order, itemsInOrder: ItemOrder) {
        if isInternetAvailable() {
            let params = ["date" : "2018-12-20T00:39:57Z", "isPaid" : false, "paymentType" : orderData.orderData.paymentType] as [String : Any]
            let str = "https://peaceful-woodland-66560.herokuapp.com/users/\(orderData.orderData.user!)/orders"
            let url = URL(string: str)
            print(url)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
                   do {
                       request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                   } catch let error {
                       print(error.localizedDescription)
                   }
                   request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                   request.addValue("application/json", forHTTPHeaderField: "Accept")
                   let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
                       guard error == nil else {
                           return
                       }
                       guard let data = data else {
                           return
                       }
                       do {
                        print("222")
                        print(data)
                                     //create json object from data
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]   {
                                for x in itemsInOrder.itemOrderData {
                                    var x1 = x
                                    x1.idOrder = (json["id"] as! String)
                                    print(json)
                                    print(x.quantity)
                                    ItemOrder().postItemOrder(itemOrderConnection: x1)
                                    
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
        }
    }
  */

