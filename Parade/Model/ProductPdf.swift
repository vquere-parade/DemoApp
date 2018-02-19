//
//  ProductPdf.swift
//  Parade
//
//  Created by Antoine Sauray on 13/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ProductPdf : ProductCategory {
    
    var pdfName: String
    
    init(title: String, segue: String, cellIdentifier: String, image: String, pdfName: String, size: CGFloat) {
        self.pdfName = pdfName
        super.init(title: title, jsonFile: nil, segue: segue, cellIdentifier: cellIdentifier, image: image, size: size)
    }
}
