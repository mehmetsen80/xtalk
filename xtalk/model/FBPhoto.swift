//
//  FBPhoto.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/18/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class FBPhoto {
    
    var album: AnyObject?
    var created_time: String?
    var id: String?
    var images: [AnyObject]?
    var link: String?
    var picture: String?
    var place: AnyObject?
    
    
    class func FBPhotoWithAnyObject(allResults: AnyObject) -> FBPhoto{
        
        let fbPhoto: FBPhoto = FBPhoto()
        
        fbPhoto.id = allResults["id"] as! String?
        fbPhoto.link = allResults["link"] as? String ?? ""
        fbPhoto.created_time = allResults["created_time"] as? String ?? ""
        fbPhoto.picture = allResults["picture"] as? String ?? ""
        fbPhoto.images = allResults["images"] as? [AnyObject]
        fbPhoto.place = allResults["place"] as AnyObject?
        fbPhoto.album = allResults["album"] as AnyObject?
        
        return fbPhoto
    }
    
    func toString() -> String{
    
        return "FBPhoto: \nid: \(self.id!) \n link: \(self.link!) \n created_time: \(self.created_time!) \n picture: \(self.picture!) place: \(self.place!) \n album: \(self.album!) \n images: \(self.images!)"
    
    }
    
}
