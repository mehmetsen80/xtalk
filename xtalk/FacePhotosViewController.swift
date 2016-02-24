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
    @IBOutlet weak var btnContinue: RoundedButton!
    
    var facebookApi: FacebookAPIController?
    var myFBPhotos: [FBMyPhoto] = [FBMyPhoto]()//create the fb photos array
    
    var pkUserID : Double!
    
    private let concurrentFacebookQueue = dispatch_queue_create("xtalk.dev.facebookQueue", DISPATCH_QUEUE_CONCURRENT)
    
    let cellHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.backgroundColor = UIColor.clearColor()
        mTableView.estimatedRowHeight = 400.0
        mTableView.rowHeight = UITableViewAutomaticDimension
        
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
                            var image = UIImage(data: noerror)
                            photo.imageData = data
                            photo.urlbase64 = data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                            cell.imgPhoto.image = image
                            //cell.imgPhoto.image? = UIImage().resizeImage(image!, targetSize: CGSize(width: self.mTableView.contentSize.width, height: (image?.size.height)!))
                            
                            let targetSize: CGSize = CGSize(width: self.mTableView.contentSize.width, height: self.mTableView.contentSize.height/2)
                            print("targetsize -> width: \(targetSize.width) height: \(targetSize.height)")
                            
                            image = UIImage().resizeImage(image!, targetSize: targetSize)
                            print("new image size -> width: \(image!.size.width)  height: \(image!.size.height)")
                            
                            //cell.imgPhoto.image? = UIImage().resizeImage(image!, targetSize: CGSize(width: self.mTableView.contentSize.width, height: self.mTableView.contentSize.height/2))
                            cell.imgPhoto.image? = image!
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
    
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        //when my photo exists
//        if let photo:FBMyPhoto = self.myFBPhotos[indexPath.row] {
//            photo.selected = photo.selected == true ? false : true
//            self.myFBPhotos[indexPath.row] = photo
//            self.mCollectionView.reloadData()
//            self.btnContinue.setTitle("Continue (\(self.selectedIndexes()) selected)", forState: .Normal)
//        }
//    }
    
//    
//    func selectedIndexes() -> Int {
//        
//        var i:Int = 0
//        for photo in self.myFBPhotos{
//            
//            if(photo.selected){
//                i++
//            }
//        }
//        
//        return i
//    }
    
    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return myFBPhotos.count
//    }
    
    @IBAction func importFacebookPhotos(sender: AnyObject) {
        
        let selectedPhoto : String = self.myFBPhotos[1].urlbase64!
        self.facebookApi?.importMyFacebookPhoto(selectedPhoto)
    }
    
    func didReceiveFacebookImportPhotoAPIResults(results: NSDictionary){
        
        print("didReceiveFacebookImportPhotosAPIResults: \n")
        print(results)
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
