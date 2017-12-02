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
import AudioToolbox
import AVFoundation

class DemoViewController : ViewController {
    var motionManager: CMMotionManager!
    var vibration : Bool = false
    
    override func viewDidLoad() {
        print("salut")
        
        DispatchQueue.global(qos: .background).async {
            while true {
                if self.vibration {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    self.toggleTorch(on: true)
                } else {
                    self.toggleTorch(on: false)
                }
                sleep(1)
            }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: .UIDeviceOrientationDidChange,
            object: nil)
    }
    
    @objc func orientationChanged(notification: NSNotification) {
        if UIDevice.current.orientation == UIDeviceOrientation.faceDown {
            print("face down")
            vibration = true
        } else {
            print("face up")
            vibration = false
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
