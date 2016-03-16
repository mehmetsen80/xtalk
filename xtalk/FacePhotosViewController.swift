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
    var activitiyViewController : ActivityViewController!
    var passedViewController : PassedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uitableview
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.backgroundColor = UIColor.clearColor()
        mTableView.estimatedRowHeight = 321
        mTableView.rowHeight = UITableViewAutomaticDimension
        mTableView.setNeedsLayout()
        mTableView.layoutIfNeeded()
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
        
        for (index,photo) in  self.myFBPhotos.enumerate(){
            
            
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
                            //convert image into 64 base string
                            photo.urlbase64 = data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                            //always keep the original image
                            photo.originalImage = originalImage
                            //new width and height, keep the table width and the original image height
                            let targetSize: CGSize = CGSize(width: self.mTableView.contentSize.width, height: (originalImage?.size.height)!)
                            //resize the original image according to the new target size and get new image
                            let newImage = UIImage().resizeImage(originalImage!, targetSize: targetSize)
                            //keep the new image on our photo model
                            photo.newImage = newImage
                            //let's set the modified photo model back to the photo array
                            self.myFBPhotos[index] = photo
                            
                        })//dispatch main queue for the image
                    }
                    else {
                        print("Error: \(error!.localizedDescription)", terminator: "")
                    }
                    
                }//end of data task
                dataTask.resume()//call data task
                
                
            }

           
        }
        
        //show 3 seconds alert of table loading... this gives us time to load the tableview
        self.activitiyViewController = ActivityViewController(message: "Loading...")
        presentViewController(self.activitiyViewController, animated: true, completion: nil)
        NSTimer.scheduledTimerWithTimeInterval(3, target:self, selector: Selector("tableLoadingDone"), userInfo: nil, repeats: false)
 
    }
    
    func tableLoadingDone(){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.mTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("fbCell", forIndexPath: indexPath) as! FBPhotoCell
        
        //when my photo exists
        if let photo:FBMyPhoto = self.myFBPhotos[indexPath.row] {
            
            cell.lblCreatedTime.text = photo.created_time
            cell.btnImport.tag = indexPath.row
            cell.btnImport.addTarget(self, action: "importThisPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.backgroundColor = UIColor.clearColor()
            cell.imgImported.image = photo.isImported  ? UIImage(named: "ok-icon-black") : nil
            cell.imgPhoto.userInteractionEnabled = true
            cell.imgPhoto.tag = indexPath.row
            
            //when the image is clicked
            let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TappedOnImage:")
            tapped.numberOfTapsRequired = 1
            cell.imgPhoto.addGestureRecognizer(tapped)
            
            
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
                            //convert image into 64 base string
                            photo.urlbase64 = data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                            //always keep the original image
                            photo.originalImage = originalImage
                            //new width and height, keep the table width and the original image height
                            let targetSize: CGSize = CGSize(width: self.mTableView.contentSize.width, height: (originalImage?.size.height)!)
                            //resize the original image according to the new target size and get new image
                            let newImage = UIImage().resizeImage(originalImage!, targetSize: targetSize)
                            //keep the new image on our photo model
                            photo.newImage = newImage
                            //show the new resized image in the cell
                            cell.imgPhoto.image? = newImage
                            
                            self.myFBPhotos[indexPath.row] = photo//let's set the modified photo back to the photo array
                            
                        })//dispatch main queue for the image
                    }
                    else {
                        print("Error: \(error!.localizedDescription)", terminator: "")
                    }
                    
                }//end of data task
                dataTask.resume()//call data task
                
            }else{
                //cell.imgPhoto.image = UIImage(data:photo.imageData)
                cell.imgPhoto.image = photo.newImage
            }
        }
        
        return cell
    }
    
    func TappedOnImage(sender:UITapGestureRecognizer){
        //manual segue to go to the scroll viewer
        self.performSegueWithIdentifier("showScrollView", sender: sender)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFBPhotos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let photo:FBMyPhoto = self.myFBPhotos[indexPath.row]
        let height: CGFloat = photo.newImage == nil ? 282 :  (photo.newImage?.size.height)! + 30
        return height
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //import facebook photo
    func importThisPhoto(sender: UIButton){
        
        //another way to get the indexPath
//              let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: self.mTableView)
//              let indexPath: NSIndexPath = self.mTableView.indexPathForRowAtPoint(buttonPosition)!
        
        
        let row = sender.tag //button row
        let photo:FBMyPhoto = self.myFBPhotos[row]
        self.facebookApi?.importMyFacebookPhoto(photo, row: row)
        
        self.activitiyViewController = ActivityViewController(message: "Importing...")
        //show loading progress bar
        presentViewController(self.activitiyViewController, animated: true, completion: nil)
    }
    
    
    
    func didReceiveFacebookImportPhotoAPIResults(results: NSDictionary, row: Int){
        
        print("didReceiveFacebookImportPhotosAPIResults: \n")
        print(results)
        
        let resultValue: Bool = results["success"] as! Bool!
        
        dispatch_barrier_async(concurrentFacebookQueue) {
            dispatch_async(dispatch_get_main_queue(), {
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                if(resultValue){
                    
                    let photo:FBMyPhoto = self.myFBPhotos[row]
                    photo.isImported = true
                    self.myFBPhotos[row] = photo
                    
                    self.passedViewController = PassedViewController(message: "Imported Successfully!")
                    self.presentViewController(self.passedViewController, animated: true, completion: nil)
                    NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("photoSuccessfullyImported"), userInfo: nil, repeats: false)
                }
            }) //dispatch main thread
        }
        
    }
    
    //facebook photo successfully imported!
    func photoSuccessfullyImported(){
        dismissViewControllerAnimated(true, completion: nil)
        self.mTableView.reloadData()
    }
  

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showScrollView"{
            let scrollViewController: ScrollViewController = segue.destinationViewController as! ScrollViewController
            
            //assign the selected row number to the start page of the scrollviewer
            if let mysender : UITapGestureRecognizer = sender as? UITapGestureRecognizer{
                let row: Int = (mysender.view?.tag)!
                scrollViewController.startPage = row
            }
  
            var photos: [UIImage]! = [UIImage]()
            for photo in self.myFBPhotos{
                if let newImage = photo.newImage{
                    photos.append(newImage)
                }
            }
            
            scrollViewController.photos = photos
        }
    }
    

}
