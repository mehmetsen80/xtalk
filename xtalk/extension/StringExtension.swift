//
//  StringExtension.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/18/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation


/************* usage: *************
var myString = "4.2"
var myDouble = myString.toDouble()
***********************************/
extension String{
    //convertes String to Double
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}