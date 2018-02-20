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
        //self.separatorInset = .zero
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.layoutMargins = .zero
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        var widthConstraintConstant = screenWidth - (2 * 12)
        if screenHeight < screenWidth {
            widthConstraintConstant = screenHeight - (2 * 12)
        }
        //let  widthConstraintConstant = screenWidth - (2 * 12)
        print("widthConstraint.constant=%f", widthConstraintConstant)
        print("screenWidth=%f", screenWidth)
        
        widthConstraint.constant = widthConstraintConstant
        heightConstraint.constant = widthConstraintConstant
    }
}
