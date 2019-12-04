//
//  Item.swift
//  FlowerStoreApp
//
//  Created by Gorbovtsova Ksenya on 25/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation

class Item: NSObject {
    var itemsList: [ItemGateway]
    
    public override init() {
        self.itemsList = [ItemGateway]()
    }
    
    public func getItems() {
        ItemGateway().getItemsGateway(itemCompletionHandler: { newList, error in
                self.itemsList = self.itemsList + newList
        })
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public func addToCart(items: [ItemGateway]) {
        self.itemsList = self.itemsList + items
    }
    


}


