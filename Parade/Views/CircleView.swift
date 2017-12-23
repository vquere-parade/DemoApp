//
//  File.swift
//  Parade
//
//  Created by Antoine Sauray on 17/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var circle = UIView()
    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //resetCircle(frame: frame, color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9).cgColor)
        resetCircle(frame: frame, color: UIColor.white.cgColor)
        addSubview(circle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetCircle(frame: CGRect, color: CGColor) {
        
        let  rectSide: CGFloat = 0
        /*
        if (frame.size.width > frame.size.height) {
            rectSide = frame.size.height
        } else {
            rectSide = frame.size.width
        }
        */
        
        let circleRect = frame
        circle = UIView(frame: circleRect)
        circle.backgroundColor = UIColor.clear
        circle.layer.cornerRadius = rectSide/2
        circle.layer.borderWidth = 2.0
        circle.layer.borderColor = color
    }
    
    func resizeCircle (summand: CGFloat) {
        
        frame.origin.x -= summand/2
        frame.origin.y -= summand/2
        
        frame.size.height += summand
        frame.size.width += summand
        
        circle.frame.size.height += summand
        circle.frame.size.width += summand
    }
    
    func animateChangingCornerRadius (toValue: Any?, duration: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = circle.layer.cornerRadius
        animation.toValue =  toValue
        animation.duration = duration
        circle.layer.cornerRadius = self.circle.frame.size.width/2
        circle.layer.add(animation, forKey:"cornerRadius")
    }
    
    
    func circlePulseAinmation(_ summand: CGFloat, duration: TimeInterval, completionBlock:@escaping ()->()) {
        
        UIView.animate(withDuration: duration, delay: 0,  options: .curveEaseInOut, animations: {
            self.resizeCircle(summand: summand)
        }) { _ in
            completionBlock()
        }
        
        animateChangingCornerRadius(toValue: circle.frame.size.width/2, duration: duration)
        
    }
    
    func resizeCircleWithPulseAinmation(_ summand: CGFloat,  duration: TimeInterval) {
        
        if (!isAnimating) {
            isAnimating = true
            circlePulseAinmation(summand, duration:duration) {
                self.circlePulseAinmation((-1)*summand, duration:duration) {self.isAnimating = false}
            }
        }
    }
}
