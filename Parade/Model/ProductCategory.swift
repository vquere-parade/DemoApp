//
//  Category.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ProductCategory {
    
    var title: String
    var jsonFile: String?
    var segue: String?
    var cellIdentifier: String
    var image: String?
    var size : CGFloat
    
    init(title: String, jsonFile: String?, segue: String?, cellIdentifier: String, image: String?, size: CGFloat) {
        self.title = title
        self.jsonFile = jsonFile
        self.segue = segue
        self.image = image
        self.cellIdentifier = cellIdentifier
        self.size = size
    }

}
