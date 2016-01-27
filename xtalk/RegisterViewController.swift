//
//  RegisterViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 1/26/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doSignup(sender: AnyObject) {
        
        let fullname = txtFullName.text
        let email = txtEmail.text
        let password = txtPassword.text
        
        //check for empty fields
        if(fullname!.isEmpty || email!.isEmpty || password!.isEmpty){
            //display alert message
            displayAlertMessage("All fields are required!")
            return
        }
        
        //generate url, call json and display the result
        let myUrl = NSURL(string:"http://52.89.115.179/ajax/")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
        let postString = "email=\(email)&password=\(password)&fullname=\(fullname)&processType=SIGNUPUSER"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        //self.myActivityIndicator.startAnimating()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if(error != nil){
                print("error=\(error)", terminator: "")
                return
            }
            
            do{
                let parseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers ) as? NSDictionary
                
                print("resultValue=\(parseJSON)")
                let resultValue: Bool = parseJSON?["success"] as! Bool!
                let message:String? = parseJSON?["message"] as! String?
                

                dispatch_async(dispatch_get_main_queue(),{
                    
                    //self.myActivityIndicator.stopAnimating()
                    
                    if(!resultValue){
                        //display alert message with confirmation
                        let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                        
                        //self.displayAlertMessage(message!)
                        
                    }else{
                        //let's continue to retrieve remaining user data
                        let userid:Double? = parseJSON?["userid"] as! Double?
                        let email:String? = parseJSON?["email"] as! String?
                        let fullname:String? = parseJSON?["fullname"] as! String?
                        let signupdate:String? = parseJSON?["signupdate"] as! String?
                        let isadmin:Bool = parseJSON?["isadmin"] as! Bool!
                        
                        //store data
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "xtalk_isloggedin")
                        NSUserDefaults.standardUserDefaults().setObject(userid, forKey:"xtalk_userid")
                        NSUserDefaults.standardUserDefaults().setObject(fullname, forKey:"xtalk_fullname")
                        NSUserDefaults.standardUserDefaults().setObject(email, forKey:"xtalk_email")
                        NSUserDefaults.standardUserDefaults().setObject(signupdate, forKey:"xtalk_signupdate")
                        NSUserDefaults.standardUserDefaults().setBool(isadmin, forKey: "xtalk_isadmin")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        
                        //display alert message with confirmation
                        let myAlert = UIAlertController(title: "Alert", message: "Welcome to Xtalk!", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Let's Start!", style: UIAlertActionStyle.Default){ action in
                            self.dismissViewControllerAnimated(true, completion:nil)
                        }
                        
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                        
                        //if successfull login, then jump to MainViewController
                        let mainTabBar: UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTabBar") as! UITabBarController
                        self.presentViewController(mainTabBar, animated:true, completion:nil)
                    }
                    
                })
                
                
                
                
            }catch let error {
                print("Something went wrong! \(error)")
            }
            
        }
        
        
        task.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlertMessage(alertMessage:String){
        //shortcut alert message
        let myAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
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
