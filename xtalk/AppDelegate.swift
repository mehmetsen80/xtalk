//
//  AppDelegate.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var geoCoder: CLGeocoder!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var city: String?
   
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
        
        //first require to authorize location from user
        initLocationManger()
        
        //retreive the main storyboard
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let is_user_logged_in:Bool = NSUserDefaults.standardUserDefaults().boolForKey("xtalk_isloggedin")
        if(is_user_logged_in){//if already logged in
            //user is already logged in, let's jump to main tabbar controller
            let mainTabBar : CustomTabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("mainTabBar") as! CustomTabBarController
            window!.rootViewController = mainTabBar
            window!.makeKeyAndVisible()
        }else{
            //use not logged in, so go to the login screen
            let loginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            window!.rootViewController = loginViewController
            window!.makeKeyAndVisible()
        }
        
        //return true
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
  
    
    

    
    //user is asked to authorize location to use the app
    //remember that we added these 2 lines in plist file, will use the 2nd one
    //1) NSLocationWhenInUseUsageDescription
    //2) NSLocationAlwaysUsageDescription
    func initLocationManger(){
        
        geoCoder = CLGeocoder() //first time initialization of geoCoder
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //called shortly after CLLocationManager is initialized, that is why we also request authorization from here
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization() // locationManager.requestWhenInUseAuthorization() also works
            break
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation() // start updating location
            locationManager.startMonitoringSignificantLocationChanges()
            currentLocation = self.locationManager.location != nil ? self.locationManager.location : nil
            if currentLocation != nil{
                print("didChangeAuthorizationStatus AuthorizedAlways Coords ==> latitude: \(currentLocation.coordinate.latitude) longitude: \(currentLocation.coordinate.longitude)")
                    
                    
                geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
                    placemarks, error in
                        
                    if error == nil && placemarks!.count > 0 {
                            let placeArray = placemarks as [CLPlacemark]?
                            // Place details
                            let placeMark: CLPlacemark! = placeArray?[0]
                        
                            // City
                            if let city = placeMark.addressDictionary?["City"] as? NSString {
                                //self.locationManager.stopUpdatingLocation()  // disable this if you don't want to stop updating
                                self.city = city as String
                            }
                            
                            
                        }
                })
            
            }
            break
            case .AuthorizedWhenInUse, .Restricted, .Denied: //in case user does not choose Always, then force him
                
                //let's force the user to open app's Settings to set the location to 'Always'
                let alertController = UIAlertController(title: "Location Access Disabled", message: "In order to use and notified about people near you, please open this app's settings and set location access to 'Always'.", preferredStyle: .Alert)
                
                //cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ (action) in
                    print("user refused to allow location")
                    //user refused to allow location
                    let exitController = UIAlertController(title: "You disabled your location", message: "App exits now, to use the app next time, please allow your location!", preferredStyle: .Alert)
                    let okController = UIAlertAction(title: "Ok", style: .Default){(action) in
                        print("exit application")
                        exit(0) // exit application
                    }
                    exitController.addAction(okController)
                    
                    self.window?.rootViewController?.presentViewController(exitController, animated: true, completion: nil)
                
                }
                alertController.addAction(cancelAction)//add cancel action to the alert controller
                
                // open action
                let openAction = UIAlertAction(title: "Open Settings", style: .Default){ (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)//add open action to the alert controller
                
                //finally show the alert controller
                self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                
                break
       
            
        }
    }
    
    //in case the location fails
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        
        if let clErr = CLError(rawValue: error.code) {
            switch clErr {
            case .LocationUnknown:
                print("Location Unknown", terminator: "")
            case .Denied:
                print("Denied", terminator: "")
            default:
                print("Unknown Core Location Error", terminator: "")
            }
        } else {
            print("other error", terminator: "")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print("didUpdateLocations Coords ==> latitude: \(currentLocation.coordinate.latitude) longitude: \(currentLocation.coordinate.longitude)")
    }
    

    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

