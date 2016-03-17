//
//  Office365LoginButton.swift
//  xtalk
//
//  Created by Mehmet Sen on 3/17/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class Office365LoginButton: UIButton {

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        backgroundColor = UIColor(red: 0x02/255, green: 0x4B/255, blue: 0x73/255, alpha: 1.0)
        
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 1.0, alpha: 0.7).CGColor
        layer.shadowColor = UIColor.brownColor().CGColor
        
    }

    
}
