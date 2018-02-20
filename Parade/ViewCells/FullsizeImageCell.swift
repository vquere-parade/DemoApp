//
//  FullsizeImageCell.swift
//  Parade
//
//  Created by Antoine Sauray on 20/02/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class FullsizeImageCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
        heightConstraint.constant = screenWidth - (2 * 12)
    }
}
