//
//  RoundedButton.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        backgroundColor = UIColor(red: 0xcf/255, green: 0x6e/255, blue: 0x5d/255, alpha: 1.0)
        
        //test different colors
        //backgroundColor = UIColor(red: 0x04/255, green: 0x7f/255, blue: 0xb7/255, alpha: 1.0)
        //backgroundColor = UIColor(red: 0xfa/255, green: 0x8f/255, blue: 0x37/255, alpha: 1.0)
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.7).CGColor
        layer.shadowColor = UIColor.brownColor().CGColor
        
    }

}
