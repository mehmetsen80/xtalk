//
//  Interest.swift
//  xtalk
//
//  Created by Mehmet Sen on 3/16/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class Interest {
    
    var interestid: Double?
    var name: String?
    var checked: Bool = false
    
    init(interestid: Double, name: String, checked: Bool){
        
        self.interestid = interestid
        self.name = name
        self.checked = checked
    }
    
    class func interestsWithJSON(allResults: NSArray) -> [Interest] {
        
        var interests = [Interest]()
        
        if allResults.count > 0 {
            
            for result in allResults {
                
                let interestid = result["interestid"] as? Double
                let name = result["name"] as? String
                
                let newInterest = Interest(interestid: interestid!, name: name!, checked: false)
                interests.append(newInterest)
            }
        }
        
        return interests;
    }
    
    internal func toggleCheck(){
        self.checked =  !self.checked
    }
}