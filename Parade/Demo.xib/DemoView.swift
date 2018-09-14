//
//  DemoView.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit

class DemoView: UIView {
    @IBOutlet weak var personImage: UIImageView!
    
    @IBOutlet weak var fallDetectedLabel: UILabel!
    
    @IBOutlet weak var stepsImage: UIImageView!
    
    @IBOutlet weak var alertChainLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DemoView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
