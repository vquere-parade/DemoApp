//
//  PitchDemoViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 14/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

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
            toggleTorch(on: false)
            
            return
        }
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        toggleTorch(on: true)
        
        startFallAnimation()
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            device.torchMode = on == true ? .on : .off
            
            device.unlockForConfiguration()
        } catch {
        }
    }
}
