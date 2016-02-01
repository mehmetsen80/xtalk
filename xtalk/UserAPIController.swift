//
//  UserAPIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/1/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

protocol UserAPIControllerProtocol {
    func didReceiveUserAPIResults(results: NSDictionary)
}

class UserAPIController{
    
    var delegate: UserAPIControllerProtocol
    
    init(delegate: UserAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func searchUser(pkUserID: Double){
        
//        let url = NSURL(string:"http://xtalkapp.com/ajax/Profile.php")
//        let request = NSMutableURLRequest(URL: url!)
//        //var session = NSURLSession.sharedSession()
//        request.HTTPMethod = "POST";
//        let postString = "processType=GETPROFILEPHOTO&userID=\(pkUserID)"
//        print("post profile postString: \(postString)", terminator: "")
//        //var err: NSError?
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
//            data, response, error  in
//            
//            if(error != nil) {
//                // If there is an error in the web request, print it to the console
//                print(error!.localizedDescription, terminator: "")
//            }
//            
//            do{
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                //println("Dictionary: \(json)")
//                self.delegate.didReceiveUserAPIResults(json)
//                
//            } catch {
//                //if nil
//                print("Fetch failed: \((error as NSError).localizedDescription)")
//            }
//        }
//        
//        task.resume()
        
    }
}