//
//  LineModel.swift
//  Parade
//
//  Created by Antoine Sauray on 17/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct LineModel {
    var startPoint: CGPoint
    var endPoint: CGPoint
    var lineColor: UIColor
    func drawLine() -> CAShapeLayer {
        //create the path
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        //create the line as a CAShapeLayer
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 3
        lineLayer.strokeColor = lineColor.cgColor
        return lineLayer
    }
    
    func animateComet() -> CAEmitterLayer {
        // create emitter
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerPoint
        emitter.emitterPosition = startPoint
        
        // create comet cell
        let cell = CAEmitterCell()
        cell.contents = UIImage.circle(diameter: 10, color: UIColor.white).cgImage
        cell.birthRate = 0.2 * Float(randRange(lower: 500, upper: 2000)) / 1000
        cell.lifetime = 10.0
        cell.velocity = 800
        cell.velocityRange = 700
        //add cell to the emitter
        emitter.emitterCells = [cell]
        cell.emissionLongitude = calculateAngle()
        let cometImage = UIImage.circle(diameter: 10, color: UIColor.white).rotate(withRotation: calculateAngle())
        cell.contents = cometImage.cgImage
        return emitter
    }
    
    func calculateAngle() -> CGFloat {
        let deltaX = endPoint.x - startPoint.x;
        let deltaY = endPoint.y - startPoint.y;
        return atan2(deltaY, deltaX)
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func rotate(withRotation radians: CGFloat) -> UIImage {
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
        
        
    }
}
