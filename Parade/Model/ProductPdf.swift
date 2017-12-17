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
    
    init(title: String, info: String, segue: String, cellIdentifier: String, image: String, pdfName: String) {
        self.pdfName = pdfName
        super.init(title: title, info: info, segue: segue, cellIdentifier: cellIdentifier, image: image)
    }
}
