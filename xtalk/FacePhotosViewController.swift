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
    var myFBPhotos: [FBMyPhoto]!
    
    
    private let concurrentFacebookQueue = dispatch_queue_create("com.oy.vent.facebookQueue", DISPATCH_QUEUE_CONCURRENT)
    
    let baseUrl = "https://graph.facebook.com/v2.5/"
    let cellHeight: CGFloat = 150
    //let cellWidth: CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.backgroundColor = UIColor.clearColor()
        
        mLayout.minimumInteritemSpacing = 0
        mLayout.minimumLineSpacing = 0
        
        let cellWidth = self.view.frame.width/2
        mLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        
        
        //create the fb photos array
        myFBPhotos = [FBMyPhoto]()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("We are good to go to call facebook API!")
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
    
    
    //get my facebook photos
    func didReceiveFacebookFetchMyPhotosAPIResults(results: AnyObject){
     
        self.myFBPhotos = FBMyPhoto.loadMyFBPhotos(results)
        self.mCollectionView.reloadData()
     
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("fbcell", forIndexPath: indexPath) as! FBPhotoCell
        
        //when my photo exists
        if let photo:FBMyPhoto = self.myFBPhotos[indexPath.row] {
        
            cell.lblCreatedTime.text = photo.created_time
      
            //lets' download a photo
            if photo.imageData == nil {
                    let imgURL: NSURL! = NSURL(string: photo.urlnormal!)
                    let request: NSURLRequest = NSURLRequest(URL: imgURL!)//request
            
                    //create data task
                    let dataTask =  NSURLSession.sharedSession().dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in //session calls the request
                
                        if let noerror = data {
                            dispatch_async(dispatch_get_main_queue(), {
                                let image = UIImage(data: noerror)
                                photo.imageData = data
                                cell.imgPicture.image = image
                             })//dispatch main queue for the image
                        }
                        else {
                            print("Error: \(error!.localizedDescription)", terminator: "")
                        }
        
                    }//end of data task
                    dataTask.resume()//call data task
                
            
            
                }else{
                    cell.imgPicture.image = UIImage(data:photo.imageData)
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
