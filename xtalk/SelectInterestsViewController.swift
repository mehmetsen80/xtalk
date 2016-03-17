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
        let interest:Interest = interests[indexPath.row]
        // insert the special characters using edit > emoji on the menu
        cell.textLabel!.text = interest.checked  ? "✅ " + interest.name! : interest.name!
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get the tapped row as interest object
        let interest:Interest = interests[indexPath.row]
        interest.toggleCheck()
        interests[indexPath.row] = interest
        mTableView.reloadData()

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
