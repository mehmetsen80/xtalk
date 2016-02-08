//
//  EntryViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 1/31/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate, UserAPIControllerProtocol  {

    var userApi:UserAPIController?
    private let concurrentUserQueue = dispatch_queue_create("com.oy.vent.userQueue", DISPATCH_QUEUE_CONCURRENT)
    
    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var btnSignup: RoundedButton!
    
    
    var facebookid: String!
    var fullname: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var gender: String!
    var picture: String!
    
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad()")
        
        //update city every 2 seconds, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateCity", userInfo: nil, repeats: true)

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear()")
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
          //  print("Already logged in with facebook")
        }
        else
        {
            let FBLoginView : FBSDKLoginButton = FBSDKLoginButton()
            view.addSubview(FBLoginView)
            //FBLoginView.center = self.view.center
            FBLoginView.frame = CGRectMake(0, 0, 200, 40)
            
            FBLoginView.translatesAutoresizingMaskIntoConstraints = true
            //FBLoginView.autoresizingMask = [ .FlexibleTopMargin, .FlexibleBottomMargin,
            //     .FlexibleLeftMargin, .FlexibleRightMargin ]
            FBLoginView.center = CGPointMake(view.bounds.midX, view.bounds.midY)
            
            FBLoginView.readPermissions = ["public_profile", "email", "user_birthday"]
            FBLoginView.delegate = self
        
            
            userApi = UserAPIController(delegate: self)
        }
    }
    
   
    
    //update city
    func updateCity(){
        txtCity.text = appDelegate.city
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
                self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        //"fields": "id, name, gender, email, picture.type"
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, gender, email, picture.type(large)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print(result)
                self.facebookid = result.valueForKey("id") as? String
                self.fullname = result.valueForKey("name") as? String
                self.email = result.valueForKey("email") as? String
                self.gender = result.valueForKey("gender") as? String
                self.picture = self.facebookid != "" ?  "https://graph.facebook.com/\(self.facebookid)/picture?type=large&return_ssl_resources=1" : ""
                
//                self.picture = result.valueForKey("picture") as? String
//                if let picture = result as? Dictionary<String, AnyObject>{
//                    print(picture)
//                    //self.picture = picture("url")
//                }
                print("Facebook ID: \(self.facebookid)  name: \(self.fullname) gender: \(self.gender) email: \(self.email)  picture: \(self.picture)")
                
                //facebook login
                self.userApi?.fblogin(self.facebookid, fullname: self.fullname, email: self.email, gender: self.gender)
            }
        })
    }
    
    //show alert with custom message
    func displayAlertMessage(alertMessage:String){
        //shortcut alert message
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
    }
    
    
     //let's set the received user variables into objects and fields
    func didReceiveUserFBLoginAPIResults(results: NSDictionary){
    
        dispatch_barrier_async(concurrentUserQueue) {
            
            
            let resultValue: Bool = results["success"] as! Bool!
            let message:String? = results["message"] as! String?
            print("Result\(results)")
            

            
            dispatch_async(dispatch_get_main_queue(), {
                
                if(!resultValue){
                    
                    self.displayAlertMessage(message!)
                    
                }else{
                    
                    let user: User = User.UserWithJSON(results);
                    print(user.toString())
                    
                    //store data
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "xtalk_isloggedin")
                    NSUserDefaults.standardUserDefaults().setObject(user.userid, forKey:"xtalk_userid")
                    NSUserDefaults.standardUserDefaults().setObject(user.fullname, forKey:"xtalk_fullname")
                    NSUserDefaults.standardUserDefaults().setObject(user.email, forKey:"xtalk_email")
                    NSUserDefaults.standardUserDefaults().setObject(user.signupdate, forKey:"xtalk_signupdate")
                    NSUserDefaults.standardUserDefaults().setBool(user.isadmin!, forKey: "xtalk_isadmin")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    //if successfull login, then jump to MainViewController
                    let mainTabBar: UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabBar") as! UITabBarController
                    self.presentViewController(mainTabBar, animated:true, completion:nil)
                    
                    
                }
            }) //dispatch main thread
        }
        
    
    }

    //no need to implement this here in Register
    func didReceiveUserLoginAPIResults(results:NSDictionary){}
    
    //no need to implement this here
    func didReceiveUserSignupAPIResults(results: NSDictionary){}
    
    //no need to implement this here
    func didReceiveUserSearchAPIResults(results: NSDictionary){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
