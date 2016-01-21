//
//  ViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var txtCity: UILabel!
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update city every second, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateCity", userInfo: nil, repeats: true)
    }
    
    //update city
    func updateCity(){
        txtCity.text = appDelegate.city
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}

