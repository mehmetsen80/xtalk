//
//  SelectInterestsViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 3/8/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class SelectInterestsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, InterestAPIControllerProtocol {

    @IBOutlet weak var mTableView: UITableView!
    var interests:[Interest] = [Interest]()
    private let concurrentInterestQueue = dispatch_queue_create("xtalk.dev.interestQueue", DISPATCH_QUEUE_CONCURRENT)
    var api:InterestAPIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        mTableView.delegate = self
//        mTableView.dataSource = self
//        mTableView.backgroundColor = UIColor.clearColor()
//        mTableView.rowHeight = UITableViewAutomaticDimension
//        mTableView.setNeedsLayout()
//        mTableView.layoutIfNeeded()
//        mTableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api = InterestAPIController(delegate: self)
        api?.fetchInterestList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        // Configure the cell...insert the special characters using edit > emoji on the menu
        //cell.textLabel?.text = "🔍 " + dengueSymptoms[indexPath.row]
        cell.textLabel?.text = interests[indexPath.row].name
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
        cell!.textLabel!.text = newChar + " " + interests[indexPath.row].name!
    }
    
    func didReceiveInterestListAPIResults(results: NSDictionary){
        
        dispatch_barrier_async(concurrentInterestQueue) {
            var resultsArr: [Interest] = results["results"] as! [Interest]
            dispatch_async(dispatch_get_main_queue(), {
                
                resultsArr = Interest.interestsWithJSON(resultsArr)
                for (var i = 0; i < resultsArr.count; i++) {
                    self.interests.append(resultsArr[i])
                }
                
                self.mTableView!.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            
        }
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
