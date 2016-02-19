//
//  FacePhotosViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/16/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class FacePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FacebookAPIControllerProtocol{

    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var mLayout: UICollectionViewFlowLayout!
    
    
    var facebookApi: FacebookAPIController?
    //var fbMyPhotos: FBMyPhotos!
    var myFBPhotos: [FBMyPhoto]!
    
    var imageCache = [String : UIImage]()
    
    private let concurrentFacebookQueue = dispatch_queue_create("com.oy.vent.facebookQueue", DISPATCH_QUEUE_CONCURRENT)
    
    let baseUrl = "https://graph.facebook.com/v2.5/"
    //let cellHeight: CGFloat = 120
    //let cellWidth: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCache = [String : UIImage]()

        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.backgroundColor = UIColor.clearColor()
        
        mLayout.minimumInteritemSpacing = 0
        mLayout.minimumLineSpacing = 0
        
        //let cellWidth = self.view.frame.width/2
        //mLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        
        
        //fbMyPhotos = FBMyPhotos()
        myFBPhotos = [FBMyPhoto]()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("We are good to go to call facebook API!")
            facebookApi = FacebookAPIController(delegate: self)
            facebookApi?.fetchMyPhotos()
        }
 
    }

    
    //get facebook API results for a single photo not used yet
    func didReceiveFacebookFetchPhotoAPIResults(results: AnyObject){
    
        dispatch_barrier_async(concurrentFacebookQueue) {
            let fbPhoto: FBPhoto = FBPhoto.FBPhotoWithAnyObject(results)
            print(fbPhoto.toString())
            
            //self.mCollectionView.reloadData()
            
        }
    }
    
    
    //get my facebook photos
    func didReceiveFacebookFetchMyPhotosAPIResults(results: AnyObject){
     
        dispatch_async(concurrentFacebookQueue) {
            
            //self.fbMyPhotos = FBMyPhotos.FBMyPhotosWithAnyObject(results)
            self.myFBPhotos = FBMyPhoto.loadMyFBPhotos(results)
            
            //self.facebookApi?.fetchPhoto(self.myFBPhotos[0].id)
            
            self.mCollectionView.reloadData()
            //print(self.fbMyPhotos.toString())
            //my photos
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("fbcell", forIndexPath: indexPath) as! FBPhotoCell
        
        if let photo:FBMyPhoto = self.myFBPhotos[indexPath.row] {
        
      
            if photo.imageData == nil {
            
            //lets' download a photo
            let url : String = "https://s3-us-west-2.amazonaws.com/s3-oyvent-images-16/85/8e7d64b63d85ddb7-small.jpg"
            
            //let imgURL: NSURL! = NSURL(string: photo.urlthumb!)
            let imgURL: NSURL! = NSURL(string: url)
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)//request
            
            //create data task
            let dataTask =  NSURLSession.sharedSession().dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in //session calls the request
                
                if let noerror = data {
                    dispatch_async(self.concurrentFacebookQueue) {
                        let image = UIImage(data: noerror)
                        photo.imageData = data
                        cell.mImageView.image = image
                    }
                }
                else {
                    print("Error: \(error!.localizedDescription)", terminator: "")
                }
        
                
            }//end of data task
            dataTask.resume()//call data task
            
            }else{
                cell.mImageView.image = UIImage(data:photo.imageData)
            }
            
            
        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myFBPhotos.count
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
