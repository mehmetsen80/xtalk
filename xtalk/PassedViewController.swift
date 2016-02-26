//
//  PassedViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/25/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class PassedViewController: UIViewController {
    
    let passedView = PassedView()
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .CrossDissolve
        modalPresentationStyle = .OverFullScreen
        passedView.messageLabel.text = message
        view = passedView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class PassedView: UIView {
    
    let boundingBoxView = UIView(frame: CGRectZero)
    let passedImageView = UIImageView(image: UIImage(named: "ok-icon-black")!)
    let messageLabel = UILabel(frame: CGRectZero)
    
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        boundingBoxView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        boundingBoxView.layer.cornerRadius = 12.0
        
        passedImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.shadowColor = UIColor.blackColor()
        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        messageLabel.numberOfLines = 0
        
        addSubview(boundingBoxView)
        addSubview(passedImageView)
        addSubview(messageLabel)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        boundingBoxView.frame.size.width = 160.0
        boundingBoxView.frame.size.height = 160.0
        boundingBoxView.frame.origin.x = ceil((bounds.width / 2.0) - (boundingBoxView.frame.width / 2.0))
        boundingBoxView.frame.origin.y = ceil((bounds.height / 2.0) - (boundingBoxView.frame.height / 2.0))
        
        passedImageView.frame.origin.x = ceil((bounds.width / 2.0) - (passedImageView.frame.width / 2.0))
        passedImageView.frame.origin.y = ceil((bounds.height / 2.0) - (passedImageView.frame.height / 2.0))
        
        let messageLabelSize = messageLabel.sizeThatFits(CGSizeMake(160.0 - 20.0 * 2.0, CGFloat.max))
        messageLabel.frame.size.width = messageLabelSize.width
        messageLabel.frame.size.height = messageLabelSize.height
        messageLabel.frame.origin.x = ceil((bounds.width / 2.0) - (messageLabel.frame.width / 2.0))
        messageLabel.frame.origin.y = ceil(passedImageView.frame.origin.y + passedImageView.frame.size.height + ((boundingBoxView.frame.height - passedImageView.frame.height) / 4.0) - (messageLabel.frame.height / 2.0))
        
    }
    
}