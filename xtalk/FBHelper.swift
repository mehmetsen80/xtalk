//
//  FBHelper.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/17/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FBHelper{
    
    var accessToken: FBSDKAccessToken?
    let baseUrl = "https://graph.facebook.com/v2.5/"
    
    init(){
        accessToken = FBSDKAccessToken.currentAccessToken()
    }
    
//    func fetchCoverPhoto(coverLink: String, completion:(image:UIImage)->()){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//            
//            //http://graph.facebook.com/v2.5/10150192451235958/picture?type=thumbnail
//            let userImageURL = "\(self.baseUrl)\(coverLink)?type=album&access_token=\(self.accessToken!.tokenString)";
//            
//            let url = NSURL(string: userImageURL);
//            
//            let imageData = NSData(contentsOfURL: url!);
//            
//            if let imageDataHas = imageData{
//                let image = UIImage(data: imageData!);
//                
//                completion(image: image!)
//            }
//            
//        })
//    }
//    
//    
//    func fetchAlbum(user:User){
//        
//        let userImageURL = "\(self.baseUrl)\(user.userid)/albums?access_token=\(self.accessToken!.tokenString)";
//        
//        let graphPath = "/\(user.userid)/albums";
//        let request = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
//        request.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//            if let gotError = error{
//                print(gotError.description);
//            }
//            else{
//                print(result)
//                let graphData = result.valueForKey("data") as Array;
//                var albums:[AlbumModel] = [AlbumModel]();
//                for obj:AnyObject in graphData{
//                    let desc = obj.description;
//                    //println(desc);
//                    let name = obj.valueForKey("name") as String;
//                    //println(name);
//                    let id = obj.valueForKey("id") as String;
//                    var cover = "";
//                    
//                    cover = "\(id)/picture";
//                    
//                    //println(coverLink);
//                    let link = "\(id)/photos";
//                    
//                    let model = AlbumModel(name: name, link: link, cover:cover);
//                    albums.append(model);
//                    
//                }
//                
//            }
//        }
//    }
//    
//
//    
//    
//    
//    func fetchPhoto(link:String, addItemToTable: (album:AlbumImage)->()){
//        
//        let fbRequest = FBSDKGraphRequest(graphPath: link, parameters: nil, HTTPMethod: "GET")
//        fbRequest.startWithCompletionHandler { (connection:FBSDKGraphRequestConnection!, data:AnyObject!, error:NSError!) -> Void in
//            if let gotError = error{
//                print("Error: %@", gotError)
//            }
//            else{
//                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//                    
//                    //println(data)
//                    var pictures:[AlbumImage] = [AlbumImage]();
//                    let graphData = data.valueForKey("data") as Array;
//                    var albums:[AlbumModel] = [AlbumModel]();
//                    
//                    for obj:AnyObject in graphData{
//                        //println(obj.description);
//                        //println(obj)
//                        
//                        let pictureId = obj.valueForKey("id") as String;
//                        
//                        let smallImageUrl = "\(self.baseUrl)\(pictureId)/picture?type=thumbnail&access_token=\(self.accessToken!.tokenString)";
//                        let url = NSURL(string: smallImageUrl);
//                        let picData = NSData(contentsOfURL: url!);
//                        
//                        var img:UIImage? = nil
//                        if let picDataHas = picData{
//                            img = UIImage(data: picData!);
//                        }
//                        
//                        let bigImageUrl = "\(self.baseUrl)\(pictureId)/picture?type=normal&access_token=\(self.accessToken!.tokenString)";
//                        let sourceURL = NSURL(string: bigImageUrl)
//                        let sourceData = NSData(contentsOfURL: sourceURL!)
//                        
//                        var sourceImg:UIImage? = nil
//                        if let hasSouceData = sourceData{
//                            sourceImg = UIImage(data: hasSouceData)
//                        }
//                        
//                        let commentLink = "\(self.baseUrl)\(pictureId)/comments?access_token=\(self.accessToken!.tokenString)"
//                        let likeLink = "\(self.baseUrl)\(pictureId)/likes?access_token=\(self.accessToken!.tokenString)"
//                        
//                        var commentsByUser = self.executeComment(commentLink)
//                        var likesByUser = self.executeLike(likeLink)
//                        
//                        //println(“Comment: \(commentLink)”)
//                        //println(“Like: \(likeLink)”)
//                        
//                        //pictures.append(AlbumImage(smallImage: img!, bigImage: sourceImg!));
//                        addItemToTable(album: AlbumImage(smallImage: img!, bigImage: sourceImg!, likes: likesByUser, comments: commentsByUser))
//                        //NSThread.sleepForTimeInterval(2)
//                    }
//                    NSNotificationCenter.defaultCenter().postNotificationName("photoNotification", object: nil, userInfo: nil);
//                })
//                
//            }
//        }
//        
//    }
    
}