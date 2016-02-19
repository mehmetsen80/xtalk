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
    
    var id: String!
    var name: String?
    var created_time: String?
    var urlthumb: String?
    var urlnormal: String?
    var imageData: NSData!
    
    init(data: NSDictionary){
        
        self.id = data.objectForKey("id") as! String
        self.name = data.objectForKey("name") as? String ?? ""
        self.urlthumb = "\(self.graphBaseUrl)\(id!)/picture?type=thumbnail&access_token=\(FBSDKAccessToken.currentAccessToken().tokenString)"
        self.urlnormal = "\(self.graphBaseUrl)\(id!)/picture?type=normal&access_token=\(FBSDKAccessToken.currentAccessToken().tokenString)"
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