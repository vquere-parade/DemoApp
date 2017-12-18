//
//  ShoeViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ShoeViewController : ViewController {
    
    @IBOutlet weak var showImageView: UIImageView!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var shoe: Shoe?

    override func viewDidLoad() {
        /*
        if let thisShoe = shoe {
            
            self.title = thisShoe.name
            showImageView.image = UIImage(named: thisShoe.image)
            titleTextView.text = thisShoe.name
            descriptionTextView.text = thisShoe.description
        }
         */
    }
}
