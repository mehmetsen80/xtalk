//
//  ProfileViewViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/3/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signout(sender: AnyObject) {
        
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "xtalk_isloggedin")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"xtalk_userid")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"xtalk_fullname")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"username")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"xtalk_email")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey:"xtalk_signupdate")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let loginViewController:LoginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        self.presentViewController(loginViewController, animated:true, completion:nil)
        
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
