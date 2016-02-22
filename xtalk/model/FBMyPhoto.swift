//
//  FBMyPhoto.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/19/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation


class FBMyPhoto{
    
    let graphBaseUrl = "https://graph.facebook.com/v2.5/"
    var accessToken: FBSDKAccessToken?
    
    var id: String!
    var name: String?
    var created_time: String?
    var urlthumb: String?
    var urlnormal: String?
    var imageData: NSData!
    var selected: Bool = false
    
    init(data: NSDictionary){
        
        accessToken = FBSDKAccessToken.currentAccessToken()
        
        id = data.objectForKey("id") as! String
        name = data.objectForKey("name") as? String ?? ""
        created_time = data.objectForKey("created_time") as? String ?? nil
        
        if self.created_time != nil {
            let localtime =   NSDate().dateFromISO8601(self.created_time!).toLocalTime()
            created_time = NSDate().offsetFrom(localtime)
        }
        self.urlthumb = "\(self.graphBaseUrl)\(id!)/picture?type=thumbnail&access_token=\(accessToken!.tokenString)"
        self.urlnormal = "\(self.graphBaseUrl)\(id!)/picture?type=normal&access_token=\(accessToken!.tokenString)"
    }
    
    class func  loadMyFBPhotos(allResults: AnyObject)->[FBMyPhoto] {
        
        var myphotos: [FBMyPhoto] = [FBMyPhoto]()
        
        let resultdict = allResults.objectForKey("photos") as! NSDictionary
        let data : NSArray = resultdict.objectForKey("data") as! NSArray
        
        //add photos
        for i in 0..<data.count {
            let valueDict : NSDictionary = data[i] as! NSDictionary
            let photo: FBMyPhoto = FBMyPhoto(data: valueDict)
            myphotos.append(photo)
        }
        
        return myphotos;

        
    }
    
    func toString() -> String{
        return "id: \(self.id) name: \(self.name!) created_time: \(self.created_time) urlthumb: \(self.urlthumb) urlnormal: \(self.urlnormal) "
    }

}