//
//  TextCollectionViewCell.swift
//  Parade
//
//  Created by Antoine Sauray on 09/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import UIKit

class TextCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
    }
}
