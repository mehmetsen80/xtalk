//
//  EntryViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 1/31/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var btnLogin: RoundedButton!
    @IBOutlet weak var btnSignup: RoundedButton!
    
    
    var facebookid: String!
    var fullname: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var gender: String!
    
    
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
        //"fields": "id, name, first_name, last_name, email"
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, gender, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                self.facebookid = result.valueForKey("id") as? String
                self.fullname = result.valueForKey("name") as? String
                self.email = result.valueForKey("email") as? String
                self.gender = result.valueForKey("gender") as? String
                print("Facebook ID: \(self.facebookid)  username: \(self.fullname) firstName: \(self.firstName) lastName: \(self.lastName)  email: \(self.email) ")
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
