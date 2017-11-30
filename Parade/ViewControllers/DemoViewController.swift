//
//  DemoViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import CoreMotion

class DemoViewController : ViewController {
    var motionManager: CMMotionManager!
    
    func ViewDidLoad() {
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data: CMAccelerometerData?, error: Error?) in print("hello")
        }
    }
}
