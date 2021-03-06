//
//  PhotoSourceViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/16/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class PhotoSourceViewController: UIViewController {
    
    var zoomURL: String!
    
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //close the modal window when back from capture or gallery screen
    @IBAction func unwindFromCaptureProfilePhoto(segue: UIStoryboardSegue) {
        self.btnClose.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //close the modal window when back from zoom screen
    @IBAction func unwindFromZoomScreen(segue: UIStoryboardSegue) {
        self.btnClose.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func viewPhoto(sender: AnyObject) {
        
        //zoom profile photo
        let photoZoomView: ZoomPhotoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("photoZoomView") as! ZoomPhotoViewController
        photoZoomView.url = self.zoomURL
        self.presentViewController(photoZoomView, animated:true, completion:nil)
    }
    
    
    @IBAction func capturePhoto(sender: AnyObject) {
        
        //take photo
        let capturePhotoView: CaptureProfilePhotoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("capturePhotoView") as! CaptureProfilePhotoViewController
        capturePhotoView.launchType = PhotoSource.Camera.description
        self.presentViewController(capturePhotoView, animated:true, completion:nil)
    }
    
   
    @IBAction func fromGallery(sender: AnyObject) {
        
        //the same capture screen but opens gallery directly at first launch
        let galleryPhotoView: CaptureProfilePhotoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("capturePhotoView") as! CaptureProfilePhotoViewController
        galleryPhotoView.launchType = PhotoSource.Gallery.description
        self.presentViewController(galleryPhotoView, animated:true, completion:nil)
    }
    
}
