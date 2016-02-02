//
//  RegisterViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 1/26/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UserAPIControllerProtocol {

    
    var userApi:UserAPIController?
    private let concurrentUserQueue = dispatch_queue_create("com.oy.vent.userPhotoQueue", DISPATCH_QUEUE_CONCURRENT)
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userApi = UserAPIController(delegate: self)
    }
    
    
    @IBAction func doSignup(sender: AnyObject) {
        
        let fullname = txtFullName.text!
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        //check for empty fields
        if(fullname.isEmpty || email.isEmpty || password.isEmpty){
            //display alert message
            displayAlertMessage("All fields are required!")
            return
        }
        
        //sign up user
        self.userApi?.signup(fullname, email: email, password: password)
        
    }

    
    func displayAlertMessage(alertMessage:String){
        //shortcut alert message
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
    }
    
    //let's set the received profile variables into objects and fields
    func didReceiveUserSignupAPIResults(results:NSDictionary){
        
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
                        
                        
                        //display alert message with confirmation
                        let myAlert = UIAlertController(title: "Alert", message: "Welcome to Xtalk!", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Let's Start!", style: UIAlertActionStyle.Default){ action in
                            
                            //if successfull login, then jump to MainViewController
                            let mainTabBar: UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabBar") as! UITabBarController
                            self.presentViewController(mainTabBar, animated:true, completion:nil)
                            
                        }
                        
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    
                }
            }) //dispatch main thread
        }

    }
    
    //no need to implement this here in Register
    func didReceiveUserLoginAPIResults(results:NSDictionary){}
    
    //no need to implement this here in Register
    func didReceiveUserSearchAPIResults(results:NSDictionary){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
