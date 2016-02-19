//
//  DoubleExtension.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/2/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
