//
//  DemoViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

class DemoViewController : ViewController {
    var motionManager: CMMotionManager!
    
    override func viewDidLoad() {
        print("salut")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: .UIDeviceOrientationDidChange,
            object: nil)
    }
    
    @objc func orientationChanged(notification: NSNotification) {
        if UIDevice.current.orientation == UIDeviceOrientation.faceDown {
            print("face down")
        } else {
            print("face up")
        }
    }
}
