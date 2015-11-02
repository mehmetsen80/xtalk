//
//  CircleButton.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func drawRect(rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        layer.masksToBounds = true
        layer.cornerRadius = 120.0
    }

}
