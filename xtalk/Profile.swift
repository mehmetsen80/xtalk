//
//  Profile.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import Foundation

class Profile{
    
    var pkUserID: Double?
    var fullName: String?
    var urlLarge: String?
    var urlMedium: String?
    var urlSmall: String?
    var urlThumb: String?
    
    
    class func profileWithJSON(allResults: NSDictionary) -> Profile{
        
        let profile : Profile = Profile()
        //let's assign the returned results to our profile object
        profile.pkUserID = allResults["PKUSERID"] as? Double
        profile.fullName = allResults["FULLNAME"] as? String
        profile.urlLarge = allResults["URLLARGE"] as? String ?? ""
        profile.urlMedium = allResults["URLMEDIUM"] as? String ?? ""
        profile.urlSmall = allResults["URLSMALL"] as? String ?? ""
        profile.urlThumb = allResults["URLTHUMB"] as? String ?? ""
        
        return profile;
    }
}