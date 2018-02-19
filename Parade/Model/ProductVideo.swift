//
//  ProductVideo.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ProductVideo : ProductCategory {
    
    var videoName: String
    var videoType: String
    
    init(title: String, segue: String, cellIdentifier: String, image: String, videoName: String, videoType: String, size: CGFloat) {
        self.videoName = videoName
        self.videoType = videoType
        super.init(title: title, jsonFile: nil, segue: segue, cellIdentifier: cellIdentifier, image: image, size: size)
    }
}
