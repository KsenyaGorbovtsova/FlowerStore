//
//  UserGateway.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 28/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct user: Codable {
   var id: String?
    var name: String?
    var surname: String?
    var dateOfBirth: String?
    var email: String?
    var password: String?
    var isAdmin: Bool?
    var isSeller: Bool?
    
    
    
    
   

    
}
func getUserGateWay(userCompletionHandler: @escaping (user, Error?) -> Void)  {
    if isInternetAvailable() {
               let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
        print(userId)
              let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
              let url = URL(string: "https://peaceful-woodland-66560.herokuapp.com//users/" + userId!)!
              var request = URLRequest(url:url)
              request.httpMethod = "GET"
              if var key = accessToken {
                  key = "Bearer " + key
                  request.setValue(key, forHTTPHeaderField: "Authorization")
              }
              let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                  guard error == nil else {
                      return
                  }
                  guard let data = data else {
                      return
                  }
                  print(data)
                 let userInfo =  parseUser(data: data)
                userCompletionHandler(userInfo, nil)
                 NotificationCenter.default.post(name: .reloadUser, object: nil)
              }
              dataTask.resume()
              }
              
              else {
        DisplayWarnining(warning: "проверьте подключение к интернету", title: "Упс!", dismissing: false, sender: (Any).self)
              }
    
}

func parseUser (data: Data) -> user {
    let decoder = JSONDecoder()
    let resp = try! decoder.decode(user.self, from: data)
  //  print (resp[0])
    return resp
}

