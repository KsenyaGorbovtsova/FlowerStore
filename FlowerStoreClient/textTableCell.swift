//
//  textTableCell.swift
//  FlowerStoreClient
//
//  Created by Gorbovtsova Ksenya on 28/11/2019.
//  Copyright © 2019 development team. All rights reserved.
//

import Foundation
import UIKit

public class TexttableCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
     public func configure(text: String?, placeholder: String) {
            textField.text = text
          textField.placeholder = placeholder
    
          textField.accessibilityValue = text
           textField.accessibilityLabel = placeholder
       }
    
}
