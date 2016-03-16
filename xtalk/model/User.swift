//
//  User.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/1/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class User {
    var userid: Double?
    var email: String?
    var fullname: String?
    var gender: String?
    var birthday: String?
    var description: String?
    var facebookid: String?
    var interests: String?
    var signupdate: String?
    var isadmin: Bool?
    
    class func UserWithJSON(allResults: NSDictionary) -> User {
        
        let user : User = User()
        //let's assign the returned results to our user object
        user.userid = allResults["userid"] as! Double?
        user.fullname = allResults["fullname"] as? String ?? ""
        user.email = allResults["email"] as? String ?? ""
        user.gender = allResults["gender"] as? String ?? ""
        user.birthday = allResults["birthday"] as? String ?? ""
        user.description = allResults["description"] as? String ?? ""
        user.interests = allResults["interests"] as? String ?? ""
        user.facebookid = allResults["facebookid"] as? String ?? ""
        user.signupdate = allResults["signupdate"] as? String ?? ""
        user.isadmin = allResults["isadmin"] as? Bool ?? false
        
        return user
    }
    
    func toString() -> String{
        
        return "userid: \(self.userid!) email: \(self.email!) fullname: \(self.fullname!) gender: \(self.gender!) birthday: \(self.birthday!) description: \(self.description!) interests: \(self.interests!) facebookid: \(self.facebookid) signupdate local: \(NSDate().dateFromString(self.signupdate!).toLocalTime().stringFromDate())  signupdate UTC: \(self.signupdate!) isadmin: \(self.isadmin!)"
    }
}