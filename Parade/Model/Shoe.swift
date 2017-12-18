//
//  Shoe.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class Shoe {
    
    class ShoeView {
        var image: String
        var mimeType: String
        var htmlType: String
        var content: String
        
        init(image: String, mimeType: String, htmlType: String, content: String) {
            self.image = image
            self.mimeType = mimeType
            self.htmlType = htmlType
            self.content = content
        }
    }
    
    var title: String
    var productId: String
    var shoeViewSequence : [ShoeView]
    var image: String
    
    init(title: String, productId: String, image: String, shoeViewSequence: [ShoeView]) {
        self.title = title
        self.image = image
        self.productId = productId
        self.shoeViewSequence = [ShoeView]()
    }
}
