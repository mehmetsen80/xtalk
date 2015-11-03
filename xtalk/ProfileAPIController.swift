//
//  ProfileAPIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import Foundation

protocol ProfileAPIControllerProtocol {
    func didReceiveProfileAPIResults(results: NSDictionary)
}

class ProfileAPIController{
    
    var delegate: ProfileAPIControllerProtocol
    
    init(delegate: ProfileAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchProfile(pkUserID: Double) {
        //to do: search profile details
    }
    
    func searchPhoto(pkUserID: Double){
        postProfilePhoto(pkUserID)
    }
    
    func postProfilePhoto(pkUserID: Double){
        let url = NSURL(string:"http://oyvent.com/ajax/Feeds.php")
        let request = NSMutableURLRequest(URL: url!)
        //var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST";
        let postString = "processType=GETPROFILEPHOTO&userID=\(pkUserID)"
        print("post profile postString: \(postString)", terminator: "")
        //var err: NSError?
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription, terminator: "")
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                //println("Dictionary: \(json)")
                self.delegate.didReceiveProfileAPIResults(json)
                
            } catch {
                //if nil
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
        
        task.resume()
        
    }
}