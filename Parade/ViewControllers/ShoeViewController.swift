//
//  ShoeViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ShoeViewController : UITableViewController {
    
    @IBOutlet weak var showImageView: UIImageView!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var shoe: Shoe.Model?

    override func viewDidLoad() {
        print("content:")
        for vs in (shoe?.viewSequence)! {
            print(vs.content)
        }
        
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
