//
//  Office365.swift
//  xtalk
//
//  Created by Mehmet Sen on 3/17/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation
import UIKit

class Office365 {
    
    var tenant: String
    var authority: String
    var clientID: String
    let redirectUri: NSURL
    //var resources:Dictionary<String, Resource> = Dictionary<String, Resource>()
    let discoveryServiceEndpoint: String
    let discoveryResource: String
    
    
    init(clientID: String, redirectUri: String){
        
        self.clientID = clientID
        self.redirectUri = NSURL(string: redirectUri)!
        self.tenant = "nau3203.onmicrosoft.com"
        self.authority = "https://login.windows.net/\(self.tenant)"
        self.discoveryServiceEndpoint = "https://api.office.com/discovery/v1.0/me"
        self.discoveryResource = "https://api.office.com/discovery"
    }
    
    class func getInstance() -> Office365{
        
        let office365 = Office365(clientID: "8f59d4e7-e940-40c0-8498-06c751e40551", redirectUri: "http://xtalkapp.com/office365clientios/oauth2.php")
        
        return office365
        
    }
}