//
//  UserAPIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/1/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

protocol UserAPIControllerProtocol {
    func didReceiveUserLoginAPIResults(results: NSDictionary)
    func didReceiveUserSignupAPIResults(results: NSDictionary)
    func didReceiveUserFBLoginAPIResults(results: NSDictionary)
    func didReceiveUserSearchAPIResults(results: NSDictionary)
}

class UserAPIController{
    
    //to get latitude and longitude
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //custom user api controller protocol
    var delegate: UserAPIControllerProtocol
    
    init(delegate: UserAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    //starndard xtalk login
    func login(email: String, password: String){
        
        //generate url, call json and display the result
        let myUrl = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
        let postString = "processType=LOGINUSER&email=\(email)&password=\(password)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if(error != nil){
                print("error=\(error)")
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                
                self.delegate.didReceiveUserLoginAPIResults(json)
                
            } catch let error {
                print("Something went wrong! \(error)")
            }
        }
        
        task.resume()
    }
    
    //standard xtalk signup
    func signup(fullname: String, email: String, password: String){
        
        let myUrl = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
        let postString = "email=\(email)&password=\(password)&fullname=\(fullname)&processType=SIGNUPUSER"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if(error != nil){
                print("error=\(error)", terminator: "")
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                
                self.delegate.didReceiveUserSignupAPIResults(json)
                
            }catch let error {
                print("Something went wrong! \(error)")
            }
            
        }
        
        
        task.resume()

    }
    
    
    // facebook login
    func fblogin(facebookid: String, fullname: String, email: String, gender: String){
        
        let myUrl = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
        let postString = "email=\(email)&facebookid=\(facebookid)&fullname=\(fullname)&gender=\(gender)&latitude=\(self.appDelegate.currentLocation.coordinate.latitude)&longitude=\(self.appDelegate.currentLocation.coordinate.longitude)&processType=FBLOGIN"
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
                
                self.delegate.didReceiveUserFBLoginAPIResults(json)
                
            }catch let error {
                print("Something went wrong! \(error)")
            }
            
        }
        
        
        task.resume()
    }
    
    
    //not used right now
    func search(pkUserID: Double){
        
        let url = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: url!)
        //var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST";
        let postString = "processType=GETUSER&userID=\(pkUserID)"
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
                self.delegate.didReceiveUserSearchAPIResults(json)
                
            } catch {
                //if nil
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
        
        task.resume()
        
    }
}