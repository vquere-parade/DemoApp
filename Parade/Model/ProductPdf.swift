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
    
    init(title: String, subTitle: String, segue: String, cellIdentifier: String, image: String, pdfName: String) {
        self.pdfName = pdfName
        super.init(title: title, subTitle: subTitle, segue: segue, cellIdentifier: cellIdentifier, image: image)
    }
}
