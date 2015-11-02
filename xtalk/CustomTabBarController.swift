//
//  CustomTabBarController.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/2/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // enable this if you need later to customize the tabBar backgroundimage
        //        var bg: UIImage = UIImage(named: "background-image")!
        //        bg = UIImage().resizeImage(bg,targetSize: CGSize(width: bg.size.width, height: 50))
        //        UITabBar.appearance().backgroundImage = bg
        
        
        //if above not used, then use this
        UITabBar.appearance().backgroundImage = UIImage() // clears the tabbar background image
        //UITabBar.appearance().shadowImage = UIImage() // cears the tabbar shadow image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        print("tabBarController selectedIndex: \(tabBarController.selectedIndex)", terminator: "")
        
        if (tabBarController.selectedIndex == 0) {
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
