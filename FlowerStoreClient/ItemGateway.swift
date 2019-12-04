//
//  ItemGateway.swift
//  FlowerStoreApp
//
//  Created by Gorbovtsova Ksenya on 25/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation

class ItemGateway: Codable, Hashable {
    var id: String?
    var name: String?
    var quantity: Int?
    var price: Double?
    func getItemsGateway(itemCompletionHandler: @escaping ([ItemGateway], Error?) -> Void)  {
       // var items: [item]
        if isInternetAvailable() {
               let url = URL(string: "https://peaceful-woodland-66560.herokuapp.com/items")!
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler:   { data, response, error in
                   guard
                       error == nil,
                   (response as? HTTPURLResponse)?.statusCode == 200,
                   let data = data
                       else {
                           print("network err")
                           return
                   }
                
                let jsonDict = self.parseItems(data: data)
                   itemCompletionHandler(jsonDict, nil)
                    NotificationCenter.default.post(name: .reload, object: nil)
                
               })
            
               dataTask.resume()
               }
               
               else {
            DisplayWarnining(warning: "проверьте подключение к интернету", title: "Упс!", dismissing: false, sender: (Any).self)
               }
        
    }
    var hashValue: Int {
        return 0
    }
    static func == (lhs: ItemGateway, rhs: ItemGateway) -> Bool {
        return lhs.name == rhs.name
    }
     
    func parseItems (data: Data) -> [ItemGateway] {
        let decoder = JSONDecoder()
        let resp = try! decoder.decode([ItemGateway].self, from: data)
      //  print (resp[0])
        return resp
    }
    
}
    

