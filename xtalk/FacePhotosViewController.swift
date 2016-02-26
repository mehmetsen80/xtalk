//
//  FacePhotosViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/16/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class FacePhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FacebookAPIControllerProtocol{

    
    @IBOutlet weak var mTableView: UITableView!
    
    var facebookApi: FacebookAPIController?
    var myFBPhotos: [FBMyPhoto] = [FBMyPhoto]()//create the fb photos array
    var pkUserID : Double!
    private let concurrentFacebookQueue = dispatch_queue_create("xtalk.dev.facebookQueue", DISPATCH_QUEUE_CONCURRENT)
    let activitiyViewController = ActivityViewController(message: "Importing...")
    let passedViewController = PassedViewController(message: "imported Successfully!")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uitableview
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.backgroundColor = UIColor.clearColor()
        mTableView.rowHeight = UITableViewAutomaticDimension
        mTableView.reloadData()
        
        
        //only if logged in with facebook
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            //We are good to go to call facebook API!
            facebookApi = FacebookAPIController(delegate: self)
            facebookApi?.fetchMyPhotos()//let's fetch my facebook photos
        }
    }

    
    //get facebook API results for a single photo not used yet
    func didReceiveFacebookFetchPhotoAPIResults(results: AnyObject){
    
        dispatch_barrier_async(concurrentFacebookQueue) {
            let fbPhoto: FBPhoto = FBPhoto.FBPhotoWithAnyObject(results)
            print(fbPhoto.toString())
        }
    }
    
    //custom facebook login, not used here, no need to implement this here
    func didReceiveFacebookLoginAPIResults(results: NSDictionary){}
    
    //get my facebook photos
    func didReceiveFacebookFetchMyPhotosAPIResults(results: AnyObject){
        
        self.myFBPhotos = FBMyPhoto.loadMyFBPhotos(results)
        self.mTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("fbCell", forIndexPath: indexPath) as! FBPhotoCell
        cell.activityIndicator.startAnimating()
        
        //when my photo exists
        if let photo:FBMyPhoto = self.myFBPhotos[indexPath.row] {
            
            cell.lblCreatedTime.text = photo.created_time
            
            //lets' download a photo
            if photo.imageData == nil {
                let imgURL: NSURL! = NSURL(string: photo.url!)
                let request: NSURLRequest = NSURLRequest(URL: imgURL!)//request
                
                //create data task
                let dataTask =  NSURLSession.sharedSession().dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in //session calls the request
                    
                    if let noerror = data {
                        dispatch_async(dispatch_get_main_queue(), {
                            let originalImage = UIImage(data: noerror)
                            photo.imageData = data
                            photo.urlbase64 = data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                            photo.originalImage = originalImage
                            let targetSize: CGSize = CGSize(width: self.mTableView.contentSize.width, height: (originalImage?.size.height)!)
                            let newImage = UIImage().resizeImage(originalImage!, targetSize: targetSize)
                            photo.newImage = newImage
                            cell.imgPhoto.image? = newImage
                            cell.activityIndicator.stopAnimating()
                            
                            cell.btnImport.tag = indexPath.row
                            cell.btnImport.addTarget(self, action: "importThisPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            //let's set the modified photo back to the photo array
                            self.myFBPhotos[indexPath.row] = photo
                            
                            
                            //print("image original size -> width: \(originalImage?.size.width)  height: \(originalImage?.size.height)")
                                                        //print("targetsize -> width: \(targetSize.width) height: \(targetSize.height)")
                            //print("new image size -> width: \(newImage!.size.width)  height: \(newImage!.size.height)")
                            //cell.imgPhoto.image? = UIImage().resizeImage(image!, targetSize: CGSize(width: self.mTableView.contentSize.width, height: self.mTableView.contentSize.height/2))
                            
                        })//dispatch main queue for the image
                    }
                    else {
                        print("Error: \(error!.localizedDescription)", terminator: "")
                    }
                    
                }//end of data task
                dataTask.resume()//call data task
                
                self.myFBPhotos[indexPath.row] = photo
                
            }else{
                cell.imgPhoto.image = UIImage(data:photo.imageData)
            }
            //Unselected           //Selected
            cell.backgroundColor = photo.selected == false ? UIColor.clearColor() : UIColor.whiteColor()
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFBPhotos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let photo:FBMyPhoto = self.myFBPhotos[indexPath.row]
        let height: CGFloat = photo.newImage == nil ? 350 :  (photo.newImage?.size.height)! + 30
        return height
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //import facebook photo
    func importThisPhoto(sender: UIButton){
        
        //another way to get the indexPath
        //        let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: self.mTableView)
        //        let indexPath: NSIndexPath = self.mTableView.indexPathForRowAtPoint(buttonPosition)!
        
        
        let row = sender.tag //button row
        let photo:FBMyPhoto = self.myFBPhotos[row]
        self.facebookApi?.importMyFacebookPhoto(photo.urlbase64!)
        //show loading progress bar
        presentViewController(self.activitiyViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func Next(sender: AnyObject) {
    }

    
    func didReceiveFacebookImportPhotoAPIResults(results: NSDictionary){
        
        print("didReceiveFacebookImportPhotosAPIResults: \n")
        print(results)
        
        let resultValue: Bool = results["success"] as! Bool!
        
        dispatch_barrier_async(concurrentFacebookQueue) {
            dispatch_async(dispatch_get_main_queue(), {
            
                self.dismissViewControllerAnimated(true, completion: nil)
                
                if(resultValue){
                    self.presentViewController(self.passedViewController, animated: true, completion: nil)
                    NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("photoSuccessfullyImported"), userInfo: nil, repeats: false)
                }
            }) //dispatch main thread
        }
        
   
    }
    
    //facebook photo successfully imported!
    func photoSuccessfullyImported(){
        print("photo imported, let's show yeyyy message!")
        dismissViewControllerAnimated(true, completion: nil)
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
