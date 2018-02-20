//
//  FullsizeTextCell.swift
//  Parade
//
//  Created by Antoine Sauray on 20/02/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class FullsizeTextCell : UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
    }
}
