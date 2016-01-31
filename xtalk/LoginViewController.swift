//
//  LoginViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate  {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCity: UILabel!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //update city every 2 seconds, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateCity", userInfo: nil, repeats: true)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
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
        let myUrl = NSURL(string:"http://52.89.115.179/ajax/")
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
                
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //if invalid useer
                    if(!resultValue){
                        //display alert message with confirmation
                        let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                        
                    }else{
                        //let's continue to retrieve remaining user data
                        let userid:Double? = parseJSON?["userid"] as! Double?
                        let email:String? = parseJSON?["email"] as! String?
                        let fullname:String? = parseJSON?["fullname"] as! String?
                        let signupdate:String? = parseJSON?["signupdate"] as! String?
                        let isadmin:Bool = parseJSON?["isadmin"] as! Bool!
                        
                        //store data on device
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "xtalk_isloggedin")
                        NSUserDefaults.standardUserDefaults().setObject(userid, forKey:"xtalk_userid")
                        NSUserDefaults.standardUserDefaults().setObject(fullname, forKey:"xtalk_fullname")
                        NSUserDefaults.standardUserDefaults().setObject(email, forKey:"xtalk_email")
                        NSUserDefaults.standardUserDefaults().setObject(signupdate, forKey:"xtalk_signupdate")
                        NSUserDefaults.standardUserDefaults().setBool(isadmin, forKey: "xtalk_isadmin")
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
    
    
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                print(result)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
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
