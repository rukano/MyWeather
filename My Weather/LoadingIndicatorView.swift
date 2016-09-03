//
//  LoadingIndicatorView.swift
//  My Weather
//
//  View for the translucent Loading widget with message and activity indicator
//  It start as active and can be deactivated by stopAnimating()
//  The removal from the superview should happen where instantiated
//
//  Created by Juan A. Romero on 01/09/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {
    
    var activityIndicator: UIActivityIndicatorView?
    var messageLabel: UILabel?
    var isActive = false
    
    // initializer for nibs
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // initializer for frames
    override init(frame: CGRect) {
        super.init(frame: frame)

        isActive = true
        
        // Set round corners and translusence
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)

        // Create custom message (loading)
        messageLabel = UILabel(frame: CGRect(x: 50, y:0, width: 200, height: 50))
        messageLabel!.text = "Loading..."
        messageLabel!.textColor = UIColor.whiteColor()
        
        // Create spinning wheel
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator!.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator!.startAnimating()
        
        // Add and display views
        self.addSubview(activityIndicator!)
        self.addSubview(messageLabel!)
    }
    
    func stopAnimating() {
        if isActive {
            self.activityIndicator?.stopAnimating()
            self.isActive = false
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
