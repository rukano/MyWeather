//
//  SplashScreenView.swift
//  My Weather
//
//  Created by Juan A. Romero on 01/09/16.
//  Copyright © 2016 Juan A. Romero. All rights reserved.
//

import UIKit

class SplashScreenView: UIView {
    
    var changesLabel: UILabel?
    
    // initializer for nibs
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // initializer for frames
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Tap to dismiss recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.addGestureRecognizer(tapRecognizer)
        self.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.99)
        
        // Main title
        let title = UILabel(frame: CGRect(x: 0, y: 50, width: self.bounds.width, height: 50))
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont.boldSystemFontOfSize(24)
        title.text = "My Weather"
        
        // Welcome message and features
        let message = UILabel(frame: CGRect(x: 20, y: 125, width: self.bounds.width - 40, height: 200))
        message.textColor = UIColor.whiteColor()
        message.textAlignment = NSTextAlignment.Natural
        message.numberOfLines = 0
        message.font = UIFont.systemFontOfSize(14)
        message.text = "Features:\n\n* Look for a city from the search bar\n* Tap the city for detailed view\n* Pull to reload all your cities\n* Remove by swiping to the left\n* Reorder or delete using the edit button"
        
        // Change log
        let changes = UILabel(frame: CGRect(x: 20, y: 350, width: self.bounds.width - 40, height: 200))
        changes.textColor = UIColor.whiteColor()
        changes.textAlignment = NSTextAlignment.Natural
        changes.numberOfLines = 0
        changes.font = UIFont.italicSystemFontOfSize(11)
        changes.text = "No changes since the last version"
        changesLabel = changes
        
        // Add and display the subviews
        self.addSubview(title)
        self.addSubview(message)
        self.addSubview(changes)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    func dismissView(recognizer: UITapGestureRecognizer) {
        self.resignFirstResponder()
        self.removeFromSuperview()
    }
    
    func setChanges(text: String?) {
        changesLabel!.text = text
    }
    
}
