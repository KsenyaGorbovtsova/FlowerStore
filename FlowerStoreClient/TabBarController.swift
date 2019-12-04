//
//  TabBarController.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 26/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
@IBInspectable var defaultIndex: Int = 1

override func viewDidLoad() {
    super.viewDidLoad()
    selectedIndex = defaultIndex
    let nav = self.viewControllers![0] as? UINavigationController
    let vc = nav?.topViewController as! OrderController
    
    NotificationCenter.default.addObserver(vc, selector: #selector(OrderController.setAddedToCartItems(notification:)), name: .addedToCartItems, object: nil)
}
}
