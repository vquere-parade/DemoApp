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
import SwiftyJSON
import Alamofire

class DemoViewController : ViewController {
    
    
    @IBOutlet weak var container: UIView!
    var motionManager: CMMotionManager!
    var vibration : Bool = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var fallImage: UIImageView!
    
    let queue = DispatchQueue(label: "animationQueue", qos: .background)
    var circle : CircleView?
    
    override func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
            var keepGoing = true
            while keepGoing {
                if self.vibration {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    self.toggleTorch(on: true)
                } else {
                    self.toggleTorch(on: false)
                }
                DispatchQueue.main.async {
                    if self.viewIfLoaded?.window == nil {
                        keepGoing = false
                        self.toggleTorch(on: false)
                    }
                }
                if keepGoing {
                    sleep(1)
                }
                
            }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: .UIDeviceOrientationDidChange,
            object: nil)

        
        blur()
        animate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func animate() {
        //circles.append(CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)))
        //circles.append(CircleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)))
        circle = CircleView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.circle?.center = view.center
        self.view?.addSubview(circle!)
        var size = self.view.frame.width * 0.9
        if self.view.frame.height < size {
            size = self.view.frame.height * 0.9
        }
        queue.async {
            while true {
                DispatchQueue.main.async {
                    self.circle?.resizeCircleWithPulseAinmation(size, duration: 1.0)
                }
                sleep(1)
            }
        }
    }
    
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        // 2
        let blurView = CustomIntensityVisualEffectView(effect: darkBlur, intensity: CGFloat(0.5))
        blurView.frame = view.bounds
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
            // trigger the fall event
            Alamofire.request("https://bla", method: .post, parameters: ["id": "", "key": ""], encoding: JSONEncoding.default, headers: HTTPHeaders()).response { response in
                if response.response?.statusCode == 200 {
                    // success
                } else {
                    // failure
                }
            }
        } else {
            print("face up")
            vibration = false
        }
        self.circle?.removeFromSuperview()

        blur()
        animate()
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
