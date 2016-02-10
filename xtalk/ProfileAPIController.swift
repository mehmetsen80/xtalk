//
//  ProfileAPIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import Foundation


protocol ProfileAPIControllerProtocol {
    func didReceiveGetProfileAPIResults(results: NSDictionary)
    func didReceivePostProfilePhotoAPIResults(results: NSDictionary)
}

class ProfileAPIController{
    
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var delegate: ProfileAPIControllerProtocol
    
    init(delegate: ProfileAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchProfile(userid: Double) {
        
        let url = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST";
        let postString = "processType=GETPROFILE&userid=\(userid)"
        print("post profile postString: \(postString)", terminator: "")
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
                self.delegate.didReceiveGetProfileAPIResults(json)
                
            } catch {
                //if nil
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
        
       
        task.resume()
    }
    
    func postProfilePhoto(boundary: String, body: NSData){
        
        let url = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if(error != nil){
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            // let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            // print("****** response data = \(responseString!)")
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers  ) as! NSDictionary
                //println("Dictionary: \(json)")
                self.delegate.didReceivePostProfilePhotoAPIResults(json)
                
            }catch{
                //if nil
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
        }
        
        task.resume()
        
        
    }
    
}