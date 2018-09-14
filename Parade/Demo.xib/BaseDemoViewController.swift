//
//  BaseDemoViewController.swift
//  Parade
//
//  Created by Simon Le Bras on 13/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit

class BaseDemoViewController: UIViewController {
    private static let blinkAnimationDuration = 0.7
    private static let blinkAnimationDelay = 1.5
    private static let blinkAnimationRepeatCount: Float = 3.5
    
    @IBOutlet weak var demoView: DemoView!
    
    private var animtationStarted = false
    
    private var currentStep = 0
    
    private lazy var personAnimation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "contents")
        anim.duration = BaseDemoViewController.blinkAnimationDuration
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
            anim.duration = BaseDemoViewController.blinkAnimationDuration
            anim.repeatCount = BaseDemoViewController.blinkAnimationRepeatCount
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
        
        startFallDetection()
    }
    
    func startFallDetection() {
        preconditionFailure("This method must be overridden")
    }
    
    func startFallAnimation() {
        guard !animtationStarted else {
            return
        }
        
        animtationStarted = true
        
        animatePerson()
        animateSteps()
        toggleLabelsVisibility(true)
    }
    
    private func animatePerson() {
        demoView.personImage.layer.add(personAnimation, forKey: "person")
    }
    
    private func animateSteps() {
        demoView.stepsImage.image = UIImage(named: "step_0")
        demoView.stepsImage.layer.add(stepAnimations[0], forKey: "step")
    }
    
    private func toggleLabelsVisibility(_ visible: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
            let alpha = visible ? CGFloat(1) : CGFloat(0)
            
            self.demoView.fallDetectedLabel.alpha = alpha
            self.demoView.alertChainLabel.alpha = alpha
        },
                       completion: nil)
    }
}

extension BaseDemoViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animName = anim.value(forKey: "name") as? String, animName == "step" else {
            return
        }
        
        currentStep += 1
        
        guard currentStep < stepAnimations.count else {
            currentStep = 0
            
            demoView.personImage.layer.removeAllAnimations()
            
            demoView.stepsImage.image = nil
            demoView.stepsImage.layer.removeAllAnimations()
            
            toggleLabelsVisibility(false)
            
            animtationStarted = false
            
            showToast(message: NSLocalizedString("Alert chain completed", comment: "Toast message when a fall is detected"))
            
            return
        }
        
        demoView.stepsImage.image = UIImage(named: "step_\(currentStep)")
        
        let nextAnim = stepAnimations[currentStep]
        nextAnim.beginTime = CACurrentMediaTime() + BaseDemoViewController.blinkAnimationDelay
        demoView.stepsImage.layer.add(nextAnim, forKey: "step")
    }
}
