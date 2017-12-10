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
    var subTitle: String
    var segue: String
    var cellIdentifier: String
    var image: String
    
    init(title: String, subTitle: String, segue: String, cellIdentifier: String, image: String) {
        self.title = title
        self.subTitle = subTitle
        self.segue = segue
        self.image = image
        self.cellIdentifier = cellIdentifier
    }

}
