//
//  WindCompassView.swift
//  My Weather
//
//
//
//  Created by Juan A. Romero on 02/09/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit
import CoreGraphics

class WindCompassView: UIView {
    var degrees = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        // Set up context
        let ctx = UIGraphicsGetCurrentContext()
        let midX = CGRectGetMidX(rect)
        let midY = CGRectGetMidX(rect)
        
        let distance = CGFloat(midX-5)
        let angle = CGFloat((degrees / 180.0) * M_PI)
        
        // Draw compass
        let compass = UIImage(named: "compass")!
        compass.drawInRect(self.bounds)
        
        // Translate and rotate context
        CGContextTranslateCTM(ctx, midX, midY)
        CGContextRotateCTM(ctx, -angle)
        CGContextTranslateCTM(ctx, -midX, -midY)
        
        // Draw pointer
        UIColor.whiteColor().setStroke()
        UIColor.blueColor().setFill()
        let arrow = UIBezierPath()
        arrow.moveToPoint(CGPoint(x: midX, y: midY))
        arrow.addLineToPoint(CGPoint(x: midX-5, y: midY-5))
        arrow.addLineToPoint(CGPoint(x: midX+distance, y: midY))
        arrow.addLineToPoint(CGPoint(x: midX-5, y: midY+5))
        arrow.addLineToPoint(CGPoint(x: midX, y: midY))
        arrow.lineCapStyle = CGLineCap.Round
        arrow.lineWidth = 0.75
        arrow.closePath()
        arrow.fill()
        arrow.stroke()
        
    }

}
