//
//  FacePhotosViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/16/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

class FacePhotosViewController: UIViewController, FacebookAPIControllerProtocol{

    @IBOutlet weak var imgTest: UIImageView!
    
    var facebookApi: FacebookAPIController?
    private let concurrentFacebookQueue = dispatch_queue_create("com.oy.vent.facebookQueue", DISPATCH_QUEUE_CONCURRENT)
    
    let baseUrl = "https://graph.facebook.com/v2.5/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        }
    }
    
    
    //get my facebook photos
    func didReceiveFacebookFetchMyPhotosAPIResults(results: AnyObject){
     
        dispatch_async(concurrentFacebookQueue) {
            
            let fbMyPhotos: FBMyPhotos = FBMyPhotos.FBMyPhotosWithAnyObject(results)
            print(fbMyPhotos.toString())
            //my photos
            if let photos: [FBMyPhotos.Photo] = fbMyPhotos.photos{
                
                let photo: FBMyPhotos.Photo = photos[0]
                
                //lets' download a photo
                let imgURL: NSURL! = NSURL(string: photo.url!)
                let session = NSURLSession.sharedSession()//session
                let request: NSURLRequest = NSURLRequest(URL: imgURL!)//request
                //create data task
                let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in //session calls the request
            
                    if let noerror = data {
                        dispatch_async(dispatch_get_main_queue()) {
                            let image = UIImage(data: noerror)
                            photo.imageData = data
                            self.imgTest.image = image
                        }
                    }
                    else {
                        print("Error: \(error!.localizedDescription)", terminator: "")
                    }
                }//end of data task
                dataTask.resume()//call data task
                
                        
            
            }
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
