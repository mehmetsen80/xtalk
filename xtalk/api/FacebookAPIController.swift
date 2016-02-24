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
    func didReceiveFacebookLoginAPIResults(results: NSDictionary)//custom facebook login
    func didReceiveFacebookImportPhotoAPIResults(results: NSDictionary)//import facebook photos
}

class FacebookAPIController{
    
    //to get latitude and longitude
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
    
    // facebook login
    func fblogin(facebookid: String, fullname: String, email: String, gender: String){
        
        let myUrl = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
        let postString = "email=\(email)&facebookid=\(facebookid)&fullname=\(fullname)&gender=\(gender)&latitude=\(self.appDelegate.currentLocation.coordinate.latitude)&longitude=\(self.appDelegate.currentLocation.coordinate.longitude)&processType=LOGINWITHFACEBOOK"
        //print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if(error != nil){
                print("error=\(error)", terminator: "")
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                
                self.delegate.didReceiveFacebookLoginAPIResults(json)
                
            }catch let error {
                print("Something went wrong! \(error)")
            }
            
        }
        
        
        task.resume()
    }
    
    //fetch my facebook photos
    func fetchMyPhotos(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"photos.limit(16),picture"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        
            print("fetchMyPhotos: \n \(result)")
            
            if(error != nil){
                print("error=\(error)")
                return
            }
            
            self.delegate.didReceiveFacebookFetchMyPhotosAPIResults(result)
            
        })
    }
    
    //import my facebook photos
    func importMyFacebookPhoto(photo: String){
        
        let myUrl = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
       
        
        
        let  pkUserID : Double! =  NSNumberFormatter().numberFromString(NSUserDefaults.standardUserDefaults().stringForKey("xtalk_userid")!)?.doubleValue
        
        let postString = "userid=\(pkUserID)&photo=\(photo)&latitude=\(self.appDelegate.currentLocation.coordinate.latitude)&longitude=\(self.appDelegate.currentLocation.coordinate.longitude)&processType=IMPORTFACEBOOKPHOTO"
        //print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if(error != nil){
                print("error=\(error)", terminator: "")
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                //print(json)
                self.delegate.didReceiveFacebookImportPhotoAPIResults(json)
                
            }catch let error {
                print("Something went wrong! \(error)")
            }
            
        }
        
        
        task.resume()
        
    }
    
    
    
    
}