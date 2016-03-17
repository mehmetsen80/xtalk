//
//  Office365APIController.swift
//  xtalk
//
//  Created by Mehmet Sen on 3/17/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class Office365APIController{
    
    let office365: Office365 = Office365.getInstance()
   
    
//    init(){
//        
//        office365 = Office365.getInstance()
//    }
    
    func getToken(completionHandler:((Bool, String) -> Void)){
        
        let err: AutoreleasingUnsafeMutablePointer<ADAuthenticationError?> = nil
        let authContext: ADAuthenticationContext = ADAuthenticationContext(authority: office365.authority, error: err)
        
//        authContext.acquireTokenWithResource(<#T##resource: String!##String!#>, clientId: <#T##String!#>, redirectUri: <#T##NSURL!#>, promptBehavior: <#T##ADPromptBehavior#>, userId: <#T##String!#>, extraQueryParameters: <#T##String!#>, completionBlock: <#T##ADAuthenticationCallback!##ADAuthenticationCallback!##(ADAuthenticationResult!) -> Void#>)
        
        authContext.acquireTokenWithResource(office365.discoveryResource, clientId: office365.clientID, redirectUri: office365.redirectUri, userId: nil, extraQueryParameters: "client_secret=\(office365.secretID)", completionBlock: {(result: ADAuthenticationResult!)  in
            
            //validate token exists in response
            if result.status != AD_SUCCEEDED{
                completionHandler(false, result.error.description)
                
            }else{
                
                //use the discovery service to see all resource end-points
//                let request = NSMutableURLRequest(URL: NSURL(string: "https://api.office.com/discovery/me/services")!)
//                request.HTTPMethod = "GET"
//                request.setValue("application/json; odata=verbose", forHTTPHeaderField: "accept")
//                request.setValue("Bearer \(result.accessToken)", forHTTPHeaderField: "Authorization")
                
                
                
                completionHandler(true, result.accessToken)
                
            }
            
        
        })
        
    }
    
    // Logout function to clear the app's cache and remove the user's information.
    func logout() {
//        var error: ADAuthenticationError?
//        var cache: ADTokenCacheStoring = ADAuthenticationSettings.sharedInstance().defaultTokenCacheStore
//        // Clear the token cache
//        var allItemsArray = cache.allItemsWithError(&error)
//        if (!allItemsArray.isEmpty) {
//            cache.removeAllWithError(&error)
//        }
//        // Remove all the cookies from this application's sandbox. The authorization code is stored in the
//        // cookies and ADAL will try to get to access tokens based on auth code in the cookie.
//        var cookieStore = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//        if let cookies = cookieStore.cookies {
//            for cookie in cookies {
//                cookieStore.deleteCookie(cookie )
//            }
//        }
    }
    
}
