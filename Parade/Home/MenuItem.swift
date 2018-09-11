//
//  MenuItem.swift
//  Parade
//
//  Created by Simon Le Bras on 05/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit

struct MenuItem {
    let title: String
    let image: UIImage
    let imageHighlight: UIImage
    let type: Type
}

enum Type {
    case Pitch
    case Demo
    case PDF(file: String)
    case Video(file: String, type: String)
    case Collection(file: String)
    case Link(url: String)
    case Update
}
