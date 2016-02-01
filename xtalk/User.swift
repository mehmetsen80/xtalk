//
//  User.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/1/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class User {
    var pkUserID: Double?
    var email: String?
    var fullname: String?
    var gender: String?
    var birthday: String?
    var interests: String?
    
    class func UserWithJSON(allResults: NSDictionary) -> User{
        
        let user : User = User()
        //let's assign the returned results to our user object
        user.pkUserID = allResults["userid"] as? Double
        user.fullname = allResults["fullname"] as? String
        user.email = allResults["email"] as? String ?? ""
        user.gender = allResults["gender"] as? String ?? ""
        user.birthday = allResults["birthday"] as? String ?? ""
        user.interests = allResults["interests"] as? String ?? ""
        
        return user;
    }
}