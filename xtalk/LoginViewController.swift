//
//  LoginViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UserAPIControllerProtocol  {

    
    var userApi:UserAPIController?
    private let concurrentUserQueue = dispatch_queue_create("com.oy.vent.userPhotoQueue", DISPATCH_QUEUE_CONCURRENT)
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCity: UILabel!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //update city every 2 seconds, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateCity", userInfo: nil, repeats: true)
     
        userApi = UserAPIController(delegate: self)
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
        
        self.userApi?.login(email, password: password)
        
    }
    
    func displayAlertMessage(alertMessage:String){
        //shortcut alert message
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
    }
    
    func didReceiveUserLoginAPIResults(results:NSDictionary){
        
        
        dispatch_barrier_async(concurrentUserQueue) {
            
            let user: User = User.UserWithJSON(results);
            
            let resultValue: Bool = results["success"] as! Bool!
            let message:String? = results["message"] as! String?
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if(!resultValue){
                    
                    self.displayAlertMessage(message!)
                    
                }else{
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
    
    //no need to implement this here
    func didReceiveUserSignupAPIResults(results: NSDictionary){}
    
    //no need to implement this here
    func didReceiveUserFBLoginAPIResults(results: NSDictionary){}
    
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
