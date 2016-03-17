//
//  InterestAPIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 3/8/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

protocol InterestAPIControllerProtocol {
    func didReceiveInterestListAPIResults(results: NSDictionary)
}

class InterestAPIController{
    
    //custom user api controller protocol
    var delegate: InterestAPIControllerProtocol
    
    init(delegate: InterestAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func fetchInterestList(){
        
        let myUrl = NSURL(string:"http://xtalkapp.com/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
        //let postString = "email=\(email)&password=\(password)&fullname=\(fullname)&processType=SIGNUPUSER"
        let postString = "processType=FETCHACTIVEINTERESTLIST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if(error != nil){
                print("error=\(error)", terminator: "")
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                print(json)
                self.delegate.didReceiveInterestListAPIResults(json)
                
            }catch let error {
                print("Something went wrong! \(error)")
            }
            
        }
        
        
        task.resume()
    }
    
    
}
