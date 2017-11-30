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
    
    @IBOutlet weak var shoeNameTextView: UITextView!
    @IBOutlet weak var shoeImageView: UIImageView!
    @IBOutlet weak var shoeDescriptionTextView: UITextView!
    
    var shoe: Shoe?
    
    override func viewDidLoad() {
        if let thisShoe = shoe {
            shoeImageView.image = UIImage(named: thisShoe.image)
            shoeNameTextView.text = thisShoe.name
            shoeDescriptionTextView.text = thisShoe.description
        }
    }
}
