//
//  CaptureProfilePhotoViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit
import AVFoundation


enum PhotoSource:String {
    case Gallery = "Gallery"
    case Camera = "Camera"
    var description: String {
        return self.rawValue
    }
}

class CaptureProfilePhotoViewController: UIViewController, ProfileAPIControllerProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let concurrentProfileQueue = dispatch_queue_create("com.oy.vent.profilePhotoQueue", DISPATCH_QUEUE_CONCURRENT)
    var profileApi:ProfileAPIController?
    
    //to get latitude and longitude
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var launchType: String!
    var launched : Bool! = false
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    
    var captureSession: AVCaptureSession! = nil
    var previewLayer : AVCaptureVideoPreviewLayer?
    var imagePicker: UIImagePickerController!
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput?
    
    enum CameraType {
        case Front
        case Back
    }
    
    var currentCamera = CameraType.Back
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        if(launchType == PhotoSource.Gallery.description && !launched){
            launched = true
            print("Gallery selected")
            //from library
            selectFromGallery()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        initSession()
        setupDevices()
        
        //profile Api
        profileApi = ProfileAPIController(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setup the devices flip flow back and front camera
    func setupDevices(){
        
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                
                if (currentCamera == CameraType.Front) {
                    // Finally check the position and confirm we've got the front camera
                    if device.position == AVCaptureDevicePosition.Front {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            print("Capture Front device found")
                            currentCamera = CameraType.Front
                            beginSession()
                            break
                        }
                    }
                }else{
                    // Finally check the position and confirm we've got the back camera
                    if device.position == AVCaptureDevicePosition.Back {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            print("Capture Back device found")
                            currentCamera = CameraType.Back
                            beginSession()
                            break
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    // not used right now
    func hasFrontCamera() -> Bool {
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Front){
                    return true
                }
            }
        }
        
        return false
    }
    
    
    // not used right now
    func hasFlash() -> Bool {
        
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back){
                    return device.hasFlash
                }
            }
        }
        
        return false
    }
    
    
    
    func configureDevice() {
        
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch _ {
            }
            //device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }
    
    func resetSession() {
        
        let inputs = captureSession.inputs as! [AVCaptureInput]
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            print("error: \(error)")
            input = nil
        }
        if( inputs.contains(input) ) {
            do{
                captureSession.removeInput(try AVCaptureDeviceInput(device: captureDevice))
            }catch{
                
            }
        }
        
        if captureSession.running {
            captureSession.stopRunning()
            if(!self.imageView.layer.sublayers!.isEmpty){
                self.previewLayer?.removeFromSuperlayer()
            }
        }
        
        previewLayer = nil
        captureSession = nil
        imageView.image = UIImage(named: "blank")
        
    }
    
    func initSession(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err: NSError? = nil
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            err = error
            input = nil
        }
        let inputs = captureSession.inputs as! [AVCaptureInput]
        
        
        if( !inputs.contains(input) ){
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        }
        
        if err != nil {
            print("error: \(err?.localizedDescription)")
        }
        
        //create preview layer and add it the imageview and start session
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.imageView.layer.addSublayer(previewLayer!)
        if !captureSession.running {
            captureSession.startRunning()
        }
        
        
        //adjust the preview layer bounds to put the video inside the imageview
        let bounds: CGRect? = self.imageView.layer.bounds as CGRect
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer?.bounds = bounds!
        self.previewLayer?.position = CGPointMake(CGRectGetMidX(bounds!), CGRectGetMidY(bounds!))
        
        
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "xtalk-profile-photo.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.Up) {
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransformIdentity
        
        if (img.imageOrientation == UIImageOrientation.Down
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, 0, img.size.height);
                transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.UpMirrored
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContextRef = CGBitmapContextCreate(nil, Int(img.size.width), Int(img.size.height),
            CGImageGetBitsPerComponent(img.CGImage), 0,
            CGImageGetColorSpace(img.CGImage),
            CGImageGetBitmapInfo(img.CGImage).rawValue)!;
        CGContextConcatCTM(ctx, transform)
        
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored
            ) {
                
                CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage)
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImageRef = CGBitmapContextCreateImage(ctx)!
        let imgEnd:UIImage = UIImage(CGImage: cgimg)
        
        return imgEnd
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if(captureSession.running){
            captureSession.stopRunning()
        }
        
        if(imageView.layer.sublayers != nil){
            // if(!imageView.layer.sublayers.isEmpty)
            previewLayer?.removeFromSuperlayer()
        }
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            do{
                try device.lockForConfiguration()
                
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
            catch{
            }
        }
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch = touches.first!
        let touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch = touches.first!
        let touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
        
        self.view.endEditing(true);
    }
    
    
    @IBAction func fromGallery(sender: AnyObject) {
        selectFromGallery()
    }
    
    func selectFromGallery(){
        
        if(!self.captureSession.running){
            self.imageView.layer.addSublayer(previewLayer!)
            self.captureSession.startRunning()
        }
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)//4
    }
    
    @IBAction func switchCamera(sender: AnyObject) {
        
        resetSession()
        initSession()
        currentCamera =  (currentCamera == CameraType.Front) ? CameraType.Back : CameraType.Front
        setupDevices()
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
        if(!self.captureSession.running){
            self.imageView.layer.addSublayer(previewLayer!)
            self.captureSession.startRunning()
            return
        }
        
        //let videoConnection :AVCaptureConnection?
        
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                
                let initialImage : UIImage = UIImage(data: imageData)!
                let orientedImage = UIImage(CGImage: initialImage.CGImage!, scale: 1, orientation: initialImage.imageOrientation)
                
                self.imageView.image = orientedImage
                self.captureSession.stopRunning()
                
                //Save the captured preview to image
                UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
                
            })
        }
        
    }
    
    //upload profile photo
    @IBAction func uploadPhoto(sender: AnyObject) {
        
        self.btnUpload.enabled = false
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //get stored user id
        let userid: Double! = NSNumberFormatter().numberFromString(NSUserDefaults.standardUserDefaults().stringForKey("xtalk_userid")!)?.doubleValue
        
        //generate the boundary string
        let boundary = generateBoundaryString()
        
        //prepare the loaded or taken image
        let img : UIImage = self.fixOrientation(self.imageView.image!)
        let imageData = UIImageJPEGRepresentation(img, 0.5)
        //let imageData  = UIImagePNGRepresentation(img)
        
        if(imageData==nil) { return; }
        
        //parameters to be posted
        let param = [
            "processType" : "UPLOADPROFILEPHOTO",
            "userid" : "\(userid)",
            "latitude": "\(self.appDelegate.currentLocation.coordinate.latitude)",
            "longitude": "\(self.appDelegate.currentLocation.coordinate.longitude)"
        ]

        //prepare the http body
        let body: NSData = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        //finally post photo
        self.profileApi?.postProfilePhoto(boundary, body: body)
        
    }
    
    //let's set the received posted profile photo variables into objects and fields
    func didReceivePostProfilePhotoAPIResults(results:NSDictionary){
        
        dispatch_barrier_async(self.concurrentProfileQueue) {
            
            let resultValue: Bool = results["success"] as! Bool!
            let error:String? = results["error"] as! String?
            
            print(results)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.btnUpload.enabled = true
                
                if(!resultValue){
                    //display alert message
                    let myAlert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                }else{
                    //stop animating and jump to the anchored screen
                    self.btnCancel.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                }
                
                
                
            }) //dispatch main thread
        }
        
    }
    
    //just blueprint here
    func didReceiveGetProfileAPIResults(results:NSDictionary){}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
