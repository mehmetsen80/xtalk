//
//  PlacesViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 1/21/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    
    @IBOutlet weak var txtCity: UILabel!
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //update city every second, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateCity", userInfo: nil, repeats: true)
    }
    
    func updateCity(){
        txtCity.text = appDelegate.city
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
