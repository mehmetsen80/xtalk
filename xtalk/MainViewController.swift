//
//  ViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class MainViewController:  UIViewController,  UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var txtCity: UILabel!
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mTableView: UITableView!
    
    
    var dengueSymptoms = ["live in/Travel to Tropics/Subtropics", "Fever or Defervescence", "No Appetite, Has Nausea/Vomitting", "Always Sleeping/Inactive or Restless", "Muscle Aches and Pains or Headache", "Rash", "Tourniquet test Positive", "Decreasing White Blood Cells"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update city every second, retrieved from AppDelegate
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateCity", userInfo: nil, repeats: true)
    }
    
    //update city
    func updateCity(){
        txtCity.text = appDelegate.city
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dengueSymptoms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
         cell.backgroundColor = UIColor.clearColor()
        // Configure the cell...insert the special characters using edit > emoji on the menu
        //cell.textLabel?.text = "🔍 " + dengueSymptoms[indexPath.row]
        cell.textLabel?.text = dengueSymptoms[indexPath.row]
        return cell
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get the cell and text of the tapped row
        let cell = mTableView.cellForRowAtIndexPath(indexPath)
        let text = cell!.textLabel!.text!
        
        // get the first character
        let index = text.startIndex.advancedBy(1)
        let firstChar = text.substringToIndex(index)
        
        // compare the first character
        let newChar: String
        //var checkedSymptom: Bool
        
        // insert the special characters using edit > emoji on the menu
        // this is where the toggle magic happens!
        if firstChar == "✅" {
            newChar = ""
            //checkedSymptom = true
        } else {
            //newChar = "🔍"
            
            newChar = "✅ "
            //checkedSymptom = false
        }
        
        // change the cell and text of the tapped row with the new "checkbox"
        cell!.textLabel!.text = newChar + " " + dengueSymptoms[indexPath.row]
    }

}

