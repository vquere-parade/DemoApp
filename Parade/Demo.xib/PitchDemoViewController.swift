//
//  PitchDemoViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit

class PitchDemoViewController: BaseDemoViewController {

    override func startFallDetection() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(_:)),
            name: .UIDeviceOrientationDidChange,
            object: nil)
    }
    
    @objc func orientationChanged(_ notification: NSNotification) {
        guard UIDevice.current.orientation == UIDeviceOrientation.faceDown else {
            return
        }
        
        startFallAnimation()
    }
}
