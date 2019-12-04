//
//  ItemOrderGateway.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 28/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
class ItemOrderGateway: Codable {
    var quantity: Int?
    var idItem: String?
    var idOrder:String?
    
    func sendItemOder(itemOrderConnection: ItemOrderGateway) {
        if isInternetAvailable() {
            let params = ["quant": itemOrderConnection.quantity!,  "itemId": itemOrderConnection.idItem!] as [String : Any]
            let userId = KeychainWrapper.standard.string(forKey: "userId")
            let str = "https://peaceful-woodland-66560.herokuapp.com/users/" + "/orders/" + itemOrderConnection.idOrder! + "/addItem"
            print(str)
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
                print(data)
            })
            task.resume()
            }
            
        
        else {
            DisplayWarnining(warning: "проверьте подключение к интернету", title: "Упс!", dismissing: false, sender: self)
        }
    }
}
