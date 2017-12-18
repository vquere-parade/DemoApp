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
    
    class Model {
        class ViewSequence {
            var mimeType: String
            var htmlType: String
            var content: String
            init?(json: [String: Any]) {
                self.mimeType = json["mime_type"] as! String
                self.htmlType = json["html_type"] as! String
                self.content = json["content"] as! String
            }
        }
        var image: String
        var viewSequence: [ViewSequence]
    
        init?(json: [String: Any]) {
            self.image = json["image"] as! String
            self.viewSequence = [ViewSequence]()
            let viewSequence = json["view_sequence"] as! [[String: Any]]
            for vs in viewSequence {
                if let v = ViewSequence(json: vs) {
                    self.viewSequence.append(v)
                }
            }
        }
    }
    
    var title: String
    var productId: String
    var models : [Model]
    var image: String
    
    init(title: String, productId: String, image: String, models: [Model]) {
        self.title = title
        self.image = image
        self.productId = productId
        self.models = [Model]()
    }
    
    init?(json: [String: Any]) {
        self.title = json["title"] as! String
        self.image = json["image"] as! String
        self.productId = json["product_id"] as! String
        let models = json["models"] as! [[String: Any]]
        self.models = [Model]()
        for m in models {
            if let sv = Model(json: m) {
                self.models.append(sv)
            } else {
                print("fail with json")
            }
        }
        print(models)
    }
}
