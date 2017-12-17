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
    
    
    @IBOutlet weak var container: UIView!
    var motionManager: CMMotionManager!
    var vibration : Bool = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var fallImage: UIImageView!
    override func viewDidLoad() {
        blur()
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

        let circle = CircleView(frame: CGRect(x: view.center.x, y: view.center.y, width: 40, height: 40))
        //circle.backgroundColor = UIColor.clear
        //circle.center = view.center
        //circle.layer.borderColor = UIColor.white.cgColor
        //circle.layer.cornerRadius = 32.0
        //circle.layer.borderWidth = 2.0
        view.addSubview(circle)
        
        DispatchQueue.global(qos: .background).async {
            while true {
                DispatchQueue.main.async {
                    circle.resizeCircleWithPulseAinmation(30, duration: 1.0)
                }
                sleep(1)
            }
        }
    }
    
    
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        // 2
        let blurView = CustomIntensityVisualEffectView(effect: darkBlur, intensity: CGFloat(0.5))
        blurView.frame = fallImage.bounds
        blurView.tag = 101
        if let oldView = fallImage.viewWithTag(101) {
            oldView.removeFromSuperview()
        }
        // 3
        fallImage.addSubview(blurView)
        
    }
    @objc func orientationChanged(notification: NSNotification) {
        if UIDevice.current.orientation == UIDeviceOrientation.faceDown {
            print("face down")
            vibration = true
        } else {
            print("face up")
            vibration = false
        }
        blur()
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
