//
//  Shoe.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation

struct Shoe: Decodable {
    let title: String
    let productId: String
    let image: String
    let models : [Model]
    
    enum CodingKeys: String, CodingKey {
        case title
        case productId = "product_id"
        case image
        case models
    }
    
    struct Model: Decodable {
        let image: String
        let viewSequences: [ViewSequence]
        
        enum CodingKeys: String, CodingKey {
            case image
            case viewSequences = "view_sequence"
        }
        
        struct ViewSequence: Decodable {
            let mimeType: String
            let htmlType: String
            let content: String
            
            enum CodingKeys: String, CodingKey {
                case mimeType = "mime_type"
                case htmlType = "html_type"
                case content
            }
        }
    }
}
