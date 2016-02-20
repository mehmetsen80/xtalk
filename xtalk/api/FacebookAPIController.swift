//
//  FacebookAPIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/18/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

protocol FacebookAPIControllerProtocol {
    func didReceiveFacebookFetchPhotoAPIResults(results: AnyObject)//fetch a single photo
    func didReceiveFacebookFetchMyPhotosAPIResults(results: AnyObject)//fetch my photos
}

class FacebookAPIController{
    
    //custom user api controller protocol
    var delegate: FacebookAPIControllerProtocol
    
    init(delegate: FacebookAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    
    //fetch a single fb photo along with id, we haven't used this yet
    func fetchPhoto(id: String){
        
        let graphRequestPhoto : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "10156292340905363", parameters: ["fields":"picture, name, album, images, created_time, link, place"])
        graphRequestPhoto.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            print("fetchPhoto: \n \(result)")
            
            if(error != nil){
                print("error=\(error)")
                return
            }
            
            self.delegate.didReceiveFacebookFetchPhotoAPIResults(result)
            
            
        })
        
    }
    
    //fetch my facebook photos
    func fetchMyPhotos(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"photos.limit(10),picture"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        
            print("fetchMyPhotos: \n \(result)")
            
            if(error != nil){
                print("error=\(error)")
                return
            }
            
            self.delegate.didReceiveFacebookFetchMyPhotosAPIResults(result)
            
            
        })
    }
    
    
}