//
//  DemoViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import CoreMotion
import UIKit

class DemoViewController : UIViewController {
    private static let blinkAnimationDuration = 0.7
    private static let blinkAnimationDelay = 1.5
    private static let blinkAnimationRepeatCount: Float = 3.5
    
    @IBOutlet weak var personImage: UIImageView!
    
    @IBOutlet weak var fallDetectedLabel: UILabel!
    
    @IBOutlet weak var stepsImage: UIImageView!
    
    @IBOutlet weak var alertChainLabel: UILabel!
    
    private var alertTriggered = false
    
    private var currentStep = 0
    
    private lazy var personAnimation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "contents")
        anim.duration = DemoViewController.blinkAnimationDuration
        anim.repeatCount = .infinity
        anim.autoreverses = true
        anim.fromValue = UIImage(named: "person")!.cgImage
        anim.toValue =  UIImage(named: "person_highlight")!.cgImage
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return anim
    }()
    
    private lazy var stepAnimations: [CAAnimation] = {
        var animations = [CAAnimation]()
        
        for i in 1...5 {
            let anim = CABasicAnimation(keyPath: "contents")
            anim.duration = DemoViewController.blinkAnimationDuration
            anim.repeatCount = DemoViewController.blinkAnimationRepeatCount
            anim.autoreverses = true
            anim.fromValue = UIImage(named: "step_\(i)")!.cgImage
            anim.toValue =  UIImage(named: "step_\(i)_highlight")!.cgImage
            anim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
            anim.delegate = self
            anim.setValue("step", forKey: "name")
            
            animations.append(anim)
        }
        
        return animations
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged(_:)),
            name: .UIDeviceOrientationDidChange,
            object: nil)
    }
    
    @objc func orientationChanged(_ notification: NSNotification) {
        guard UIDevice.current.orientation == UIDeviceOrientation.faceDown && !alertTriggered else {
            return
        }
        
        alertTriggered = true
        
        animatePerson()
        animateSteps()
        toggleLabelsVisibility(true)
    }
    
    private func animatePerson() {
        personImage.layer.add(personAnimation, forKey: "person")
    }
    
    private func animateSteps() {
        stepsImage.image = UIImage(named: "step_0")
        stepsImage.layer.add(stepAnimations[0], forKey: "step")
    }
    
    private func toggleLabelsVisibility(_ visible: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
            let alpha = visible ? CGFloat(1) : CGFloat(0)
            
            self.fallDetectedLabel.alpha = alpha
            self.alertChainLabel.alpha = alpha
        },
        completion: nil)
    }
}

extension DemoViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animName = anim.value(forKey: "name") as? String, animName == "step" else {
            return
        }
        
        currentStep += 1
        
        guard currentStep < stepAnimations.count else {
            currentStep = 0
            
            personImage.layer.removeAllAnimations()
            
            stepsImage.image = nil
            stepsImage.layer.removeAllAnimations()
            
            toggleLabelsVisibility(false)
            
            alertTriggered = false
            
            showToast(message: NSLocalizedString("Alert chain completed", comment: "Toast message when a fall is detected"))
            
            return
        }
        
        stepsImage.image = UIImage(named: "step_\(currentStep)")
        
        let nextAnim = stepAnimations[currentStep]
        nextAnim.beginTime = CACurrentMediaTime() + DemoViewController.blinkAnimationDelay
        stepsImage.layer.add(nextAnim, forKey: "step")
    }
}
