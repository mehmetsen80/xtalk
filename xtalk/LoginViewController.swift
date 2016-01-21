//
//  LoginViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCity: UILabel!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //update city every 2 seconds, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateCity", userInfo: nil, repeats: true)
    }
    
    //update city
    func updateCity(){
        txtCity.text = appDelegate.city
    }

    @IBAction func doLogin(sender: AnyObject) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        //if empty
        if(email.isEmpty || password.isEmpty) { return }
        
        //generate url, call json and display the result
        let myUrl = NSURL(string:"http://52.89.115.179/ajax/Login.php")
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
                let parseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as? NSDictionary
                
                
                let resultValue: Bool = parseJSON?["success"] as! Bool!
                //print("resultValue=\(parseJSON)")
                
                let message:String? = parseJSON?["message"] as! String?
                let userid:Double? = parseJSON?["userid"] as! Double?
                let fullname:String? = parseJSON?["fullname"] as! String?
                let signupdate:String? = parseJSON?["signupdate"] as! String?
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //if invalid useer
                    if(!resultValue){
                        //display alert message with confirmation
                        let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                        
                    }else{
                        //store data on device
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "xtalk_isloggedin")
                        NSUserDefaults.standardUserDefaults().setObject(userid, forKey:"xtalk_userid")
                        NSUserDefaults.standardUserDefaults().setObject(fullname, forKey:"xtalk_fullname")
                        NSUserDefaults.standardUserDefaults().setObject(email, forKey:"xtalk_email")
                        NSUserDefaults.standardUserDefaults().setObject(signupdate, forKey:"xtalk_signupdate")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        //if successfull login, then jump to MainViewController
                        let mainTabBar: UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabBar") as! UITabBarController
                        self.presentViewController(mainTabBar, animated:true, completion:nil)
                        
                    }
                })
                
            } catch let error {
                print("Something went wrong! \(error)")
            }
        }
        
        task.resume()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
