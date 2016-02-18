//
//  FBMyPhotos.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/18/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class FBMyPhotos{
    
    
    
    var facebookid: String!
    var photos: [Photo] = []
    
    init(allResults: AnyObject){
        
        self.facebookid = allResults["id"] as! String
        
        let resultdict = allResults.objectForKey("photos") as! NSDictionary
        let data : NSArray = resultdict.objectForKey("data") as! NSArray
        
        //add photos
        for i in 0..<data.count {
            let valueDict : NSDictionary = data[i] as! NSDictionary
            let photo: Photo = Photo(data: valueDict)
            self.photos.append(photo)
        }
        
    }
    
    class Photo {
        let graphBaseUrl = "https://graph.facebook.com/v2.5/"
        
        var id: String!
        var name: String?
        var created_time: String?
        var url: String?
        var imageData: NSData!
        
        init(data: NSDictionary){
            self.id = data.objectForKey("id") as! String
            self.name = data.objectForKey("name") as? String ?? ""
            self.url = "\(self.graphBaseUrl)\(id!)/picture?type=normal&access_token=\(FBSDKAccessToken.currentAccessToken().tokenString)"
        }
        
        func toString() -> String{
            return "id: \(self.id) name: \(self.name!) created_time: \(self.created_time) url: \(self.url)"
        }
    }
    
    class func  FBMyPhotosWithAnyObject(allResults: AnyObject)->FBMyPhotos {
        
        let fbMyPhotos: FBMyPhotos = FBMyPhotos(allResults: allResults)
        return fbMyPhotos
        
    }
    
    func toString() -> String{
        
        var resultStr = "FBMyPhotos: \n facebookid: \(self.facebookid) "
        for photo in self.photos{
            resultStr += "\n \(photo.toString())  \n"
        }
        return resultStr
    }
    
}