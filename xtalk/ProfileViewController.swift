//
//  ProfileViewViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/3/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,  ProfileAPIControllerProtocol, UIPopoverPresentationControllerDelegate  {
    
    var profileApi:ProfileAPIController?
    private let concurrentProfileQueue = dispatch_queue_create("xtalk.dev.profilePhotoQueue", DISPATCH_QUEUE_CONCURRENT)


    @IBOutlet weak var imgProfilePhoto: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    
    
    var zoomURL : String! = ""
    var ismyprofile : Bool! = false
    var pkUserID : Double!
    var fullname : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        pkUserID =  NSNumberFormatter().numberFromString(NSUserDefaults.standardUserDefaults().stringForKey("xtalk_userid")!)?.doubleValue
        print("pkUserID \(pkUserID)")
        
        fullname = NSUserDefaults.standardUserDefaults().stringForKey("xtalk_fullname")!
        
        //profile Api to get the profile info
        profileApi = ProfileAPIController(delegate: self)
        if(pkUserID != nil){
            profileApi?.searchProfile(self.pkUserID)
        }
        
        //set rounded corner 
        imgProfilePhoto = UIImageView().defaultCorner(imgProfilePhoto)
        //assign action for imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("tapGesture:"))
        imgProfilePhoto.userInteractionEnabled = true
        imgProfilePhoto.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func signout(sender: AnyObject) {
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        //no stored objects on device anymore
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "xtalk_isloggedin")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_userid")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_fullname")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_email")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_gender")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_signupdate")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_birthday")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_description")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_interests")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "xtalk_isadmin")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let entryViewController:EntryViewController = self.storyboard!.instantiateViewControllerWithIdentifier("entryView") as! EntryViewController
        self.presentViewController(entryViewController, animated:true, completion:nil)
        
    }
    
    //tab gesture clicked whether of any assigned imageviews
    func tapGesture(gesture: UIGestureRecognizer){
        
        //if profile photo imageview clicked
        if let imageView = gesture.view as? UIImageView {
           
            //zoom photo
            if self.zoomURL != "" && self.ismyprofile == false {
                let photoZoomView: ZoomPhotoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("photoZoomView") as! ZoomPhotoViewController
                photoZoomView.url = self.zoomURL
                self.presentViewController(photoZoomView, animated:true, completion:nil)
                
            }else{//select photo type
                let selectPhotoType: PhotoSourceViewController = self.storyboard!.instantiateViewControllerWithIdentifier("selectPhotoTypeView") as! PhotoSourceViewController
                selectPhotoType.zoomURL = self.zoomURL
                selectPhotoType.modalPresentationStyle = .Popover
                selectPhotoType.preferredContentSize = CGSizeMake(240.0, 90.0)
                selectPhotoType.popoverPresentationController!.delegate = self
                selectPhotoType.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection.Any
                selectPhotoType.popoverPresentationController!.sourceView = imageView
                selectPhotoType.popoverPresentationController!.sourceRect = imageView.bounds
                self.presentViewController(selectPhotoType, animated:true, completion:nil)
            }

        }
    }
    
    
    //returned from the photo source type screen
    @IBAction func unwindFromSelectPhotoSource(segue: UIStoryboardSegue) {
        print("returned from select photo source screen")
        //update profile photo again
        self.profileApi?.searchProfile(self.pkUserID)
    }
    
    //let's set the received profile variables into objects and fields
    func didReceiveGetProfileAPIResults(results:NSDictionary){
        
        
        dispatch_barrier_async(concurrentProfileQueue) {
            let profile: Profile = Profile.profileWithJSON(results);
            dispatch_async(dispatch_get_main_queue(), {
                
                //set fullname and look if we are at our own personal profile
                self.lblFullName.text = self.fullname
                self.ismyprofile = profile.pkUserID == self.pkUserID ? true : false
         
                /***************** get main profile photo  **************/
                //if we have medium profile picture
                if(profile.urlSmall != ""){
                    // let's download it
                    let imgURL: NSURL! = NSURL(string: profile.urlSmall!)
                    self.zoomURL = profile.urlLarge! // we use that later in zoom to show the largest photo
                    //lets' download profile photo
                    let session = NSURLSession.sharedSession()//session
                    let request: NSURLRequest = NSURLRequest(URL: imgURL!)//request
                    let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in //session calls the request
                
                        if let noerror = data {
                            dispatch_async(dispatch_get_main_queue()) {
                                let image = UIImage(data: noerror)
                                self.imgProfilePhoto.image = image
                            }
                        }
                        else {
                            print("Error: \(error!.localizedDescription)", terminator: "")
                        }
                    }
                    
                    dataTask.resume()
                    /****************** end of get main profile photo  ****************/
                }else{
                    //set no photo if there is no profile photo found
                    self.imgProfilePhoto.image = UIImage(named:"no-profile-photo-yet")
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            })
            
        }
        
        
    }
    
    //just blueprint here
    func didReceivePostProfilePhotoAPIResults(results: NSDictionary){}
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
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
