//
//  ViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func jump2Login(sender: AnyObject) {
        
        let loginView: LoginViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        
        //1st way
        self.presentViewController(loginView, animated:true, completion:nil)
    }


}

