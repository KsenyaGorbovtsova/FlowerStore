//
//  User.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 28/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation


class User: NSObject {
    var userData: user
    
    public override init() {
        self.userData = user()
    }
    
    public func getUserPublicInfo() {
        getUserGateWay(userCompletionHandler: { user, error in
            self.userData = user
        })
    }
    
   
}

