//
//  ProductText.swift
//  Parade
//
//  Created by Antoine Sauray on 19/02/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ProductText : ProductCategory {
    
    var text: String
    
    init(title: String, text: String, segue: String?, cellIdentifier: String, size: CGFloat) {
        self.text = text
        super.init(title: title, jsonFile: nil, segue: segue, cellIdentifier: cellIdentifier, image: nil, size: size)
    }
}
