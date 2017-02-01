//
//  HBApi.swift
//  Hypebeast
//
//  Created by EricHo on 24/11/2015.
//  Copyright © 2015 EricHo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private struct HBError {
    //static let ReturnJsonError = "ReturnJsonError"
    static let GetMobileAppConfigError = "GetMobileAppConfigError"
    static let GetNewsFeedError = "GetNewsFeedError"
    static let GetPostError = "GetPostError"
}

class HBApi: NSObject {
    
    static var osType:String {
        return "iOS"
    }
    
    static var deviceType:String {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return "Tablet"
        case .phone:
            return "Phone"
        case .tv:
            return "TV"
        case .carPlay:
            return "CarPlay"
        default:
            return ""
        }
        //return UIDevice.currentDevice().model
    }
    
    static let header:[String:String] = ["Content-Type":"application/json","Accept":"application/json", "Device-Type":HBApi.deviceType ,"Os-Type":HBApi.osType]
//    static let converter = Converter()
   
    
    class func getNewsFeed(_ urlString: String, completionHandler: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ posts:[HBWidgetPost]?, _ nextPageUrlString:String?, _ error: NSError?) -> ())  {
        //let urlString = "http://hypebeast.com/"
        //let urlString = "http://hypebeast.com/popular"
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default , headers: HBApi.header).responseJSON { (response) in
            
            switch response.result {
            case .failure( _):
                return completionHandler(response.request, response.response, nil, nil,  response.result.error as NSError?)
            case .success(let returnJson):
                
                
                let jsonObj = JSON(returnJson)
                if let code = jsonObj["code"].int,
                    let message = jsonObj["message"].string {
                    let errorMessage = ("\(HBError.GetNewsFeedError) code:\(code), message:\(message)")
                    print(errorMessage)
                    
                    let returnError = NSError(domain: errorMessage, code: 901, userInfo: nil)
                    return completionHandler(response.request, response.response, nil, nil, returnError)
                }
                
                let jsonPostArray = jsonObj["posts"]["_embedded"]["items"].arrayValue
                let nextPageUrlString = jsonObj["posts"]["_links"]["next"]["href"].string
                
                
                var postArray = [HBWidgetPost]()
                //###############
                //offload the expensive operation from main thread
                DispatchQueue.global(qos: .userInitiated).async {
                    for eachJsonPost in jsonPostArray {
//                        let post = self.convertToPostObject(eachJsonPost)
//                        postArray.append(post)
                        
                        let postID = eachJsonPost["id"].int
                        let title: String = eachJsonPost["title"].string ?? ""
                        let subTitle:String? = eachJsonPost["excerpt"].string
                        
                        let postLink = eachJsonPost["_links"]
                        let linkURLString: String = postLink["self"]["href"].string ?? ""
                        let thumbnailURLString: String = postLink["thumbnail"]["href"].string ?? ""
                        let category:String = postLink["categories"][0]["name"].string ?? ""
                        let postTime: String = eachJsonPost["date"].string ?? ""
                        let date: Date = Date(fromString: postTime, format: .iso8601)
                        
                        let widgetPost = HBWidgetPost(postID: postID, title: title, subTitle: subTitle, linkURLString: linkURLString, thumbnailURLString:thumbnailURLString, category: category, date: date)
                        
                            
                        
                        postArray.append(widgetPost)
                        
                        //    let postID:Int? = post["id"].int
                        //    //var title: String = post["title"].string! // old
                        //    var title: String = post["title"].string ?? ""
                        //    let subTitle:String? = post["excerpt"].string
                        //
                        //    var category: String = postLinkCategories0["name"].string ?? ""
                        //
                        //
                        //    let linkURLString: String = postLink["self"]["href"].string ?? ""
                        //    let thumbnailURLString: String = postLink["thumbnail"]["href"].string ?? ""
                        //    let postTime: String = post["date"].string ?? ""
                        //    let date: Date = Date(fromString: postTime, format: .iso8601)
                        
                    }
                    DispatchQueue.main.async {
                        return completionHandler(response.request, response.response, postArray, nextPageUrlString, response.result.error as NSError?)
                    }
                }
                //###############
                
            } //end of switch case
        } //end of Alamofire
    }
    
    
    
    //MARK: - get Post
//    class func getPost(_ urlString: String, regionID:Int?=nil, completionHandler: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ post: Post?, _ error: NSError?) -> ()) {
//        
//        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default , headers: HBApi.header).responseJSON { (response) in
//            
//            switch response.result {
//            case .failure( _):
//                return completionHandler(response.request, response.response, nil,  response.result.error as NSError?)
//            case .success(let returnJson):
//                let jsonObj = JSON(returnJson)
//                //success block but page not found
//                if let code = jsonObj["code"].int,
//                    let message = jsonObj["message"].string {
//                    let errorMessage = ("\(HBError.GetPostError) code:\(code), message:\(message)")
//                    print(errorMessage)
//                    let returnError = NSError(domain: errorMessage, code: 901, userInfo: nil)
//                    return completionHandler(response.request, response.response, nil, returnError)
//                }
//                
//                
//                guard let jsonPost = jsonObj.dictionary?["post"] else {
//                    let errorMessage = ("\(HBError.GetPostError) message: Post not exist in return JSON")
//                    print(errorMessage)
//                    let returnError = NSError(domain: errorMessage, code: 901, userInfo: nil)
//                    return completionHandler(response.request, response.response, nil, returnError)
//                }
//                
//                //###############
//                //offload the expensive operation from main thread
//                
//                DispatchQueue.global(qos: .userInitiated).async {
//                    //let post:Post = self.convertToPostObject(jsonPost)
//                    DispatchQueue.main.async {
//                        completionHandler(response.request, response.response, nil, nil)
//                    }
//                }
//                
//                /* swift 2.3
//                 let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
//                 dispatch_async(queue, {
//                 let post:Post = self.convertToPostObject(jsonPost)
//                 post.fullDetails = true
//                 
//                 dispatch_async(dispatch_get_main_queue(), {
//                 completionHandler(request: response.request, response: response.response, post: post, error: nil)
//                 })
//                 })
//                 */
//                //###############
//                
//            } //end of switch
//        }
//    }
//    

    
    class func convertToPostObject(_ post: JSON) {
        
        let postLink = post["_links"]
        let postEmbedded = post["_embedded"]
        let postLinkHbtvChannel = postLink["hbtv_channel"]
        let postLinkCategories0 = postLink["categories"][0]
        let postLinkTag = postLink["tags"]
        
        //let regionID:Int? = nil // set to nil to test the alert message
        let regionID:Int? = post["blog_id"].int
        
        let postID:Int? = post["id"].int
        //var title: String = post["title"].string! // old
        var title: String = post["title"].string ?? ""
        let subTitle:String? = post["excerpt"].string
        //var category: String? = post["_links"]["categories"][0]["name"].string //old
        var category: String = postLinkCategories0["name"].string ?? ""
        let categoryURLString: String = postLinkCategories0["href"].string ?? ""
        
        //hbtv_channel
        let hbtvChannelName:String? = postLinkHbtvChannel["name"].string
        let hbtvChannelHref:String? = postLinkHbtvChannel["href"].string
        
        //let linkURLString: String = post["_links"]["self"]["href"].string! //old
        let linkURLString: String = postLink["self"]["href"].string ?? ""
        //let thumbnailURLString: String? = post["_links"]["thumbnail"]["href"].string //old
        let thumbnailURLString: String = postLink["thumbnail"]["href"].string ?? ""
        

        

        
        let shortLinkURLString = postLink["shorten_url"]["href"].string ?? ""
        
        
        //note:if no comment_status exist on the post -> assign to empty string
        let commentStatus:String = post["comment_status"].string ?? ""
        
//        let postTime: String = post["date"].string ?? ""
//        let date: Date = Date(fromString: postTime, format: .iso8601)
        

    }
    
    
       
}
