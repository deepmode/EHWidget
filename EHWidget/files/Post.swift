//
//  Posts.swift
//  hypebeast
//
//  Created by James Cheuk on 24/4/15.
//  Copyright (c) 2015 42Labs. All rights reserved.
//

import Foundation


struct HBWidgetPost {
    
    
    var postID:Int?
    var title: String
    var subTitle:String?
    var linkURLString: String
    var thumbnailURLString:String
    var date: Date
    


    
    
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

//class Post: CustomStringConvertible {
//    
//    enum CommentStatus:String {
//        case open = "open"
//        case close = "close"
//    }
//    
//    var regionID:Int? //"en", "cn", "hk", "jp", "tw"
//    var postID:Int?
//	var title: String
//    var subTitle:String?
//	var category: String
//    var categoryURLString:String
//    var hbtvChannelName:String?
//    var hbtvChannelHref:String?
//	var author: String
//	var linkURLString: String
//	var shortLinkURLString:String
//	var thumbnailURLString: String
//	var date: Date
//	var disqusIdentifier: String
//	var imageURLs: [URL] = [URL]()
//	var videoEmbedCode: String
//	var htmlContent: String
//	//var commentCount: Int = 0
//    var commentCount:Int? //load comment only when it is nil
//	var fullDetails = false
//	var tags: [Tag] = [Tag]()
//	var source: Source?
//    var commentStatus:CommentStatus
//    var openInAppBrowser:Bool = false
//    var disableSharing:Bool = false
//    var relatedPosts:[RelatedPost] = [RelatedPost]()
//    var publishDate:String?
//	
//	
//	
//    init(regionID:Int?, postID:Int?, title: String, subTitle:String?, category: String, categoryURLString:String, hbtvChannelName:String?, hbtvChannelHref:String?,  author: String, linkURLString: String, shortLinkURLString: String, thumbnailURLString: String, date: Date, disqusIdentifier: String, imageURLs: [URL], videoEmbedCode: String, htmlContent: String, tags: [Tag], sourceName: String?, sourceLink: String?, commentStatusString:String, openInAppBrowser:Bool, disableSharing:Bool, relatedPosts:[RelatedPost], publishDate:String?) {
//        self.regionID = regionID
//        self.postID = postID
//		self.title = title
//        self.subTitle = subTitle
//		self.category = category
//        self.categoryURLString = categoryURLString
//        self.hbtvChannelName = hbtvChannelName
//        self.hbtvChannelHref = hbtvChannelHref
//		self.author = author
//		self.linkURLString = linkURLString
//		self.shortLinkURLString = shortLinkURLString
//		self.thumbnailURLString = thumbnailURLString
//		self.date = date
//		self.disqusIdentifier = disqusIdentifier
//		self.videoEmbedCode = videoEmbedCode
//		self.htmlContent = htmlContent
//		self.tags = tags
//        self.imageURLs = imageURLs
//		
//        self.source = Source(title: sourceName, link: sourceLink)
//        
//        if commentStatusString == Post.CommentStatus.open.rawValue {
//            self.commentStatus = Post.CommentStatus.open
//        } else if commentStatusString == Post.CommentStatus.close.rawValue{
//            self.commentStatus = Post.CommentStatus.close
//        } else {
//            //anything else: set to "close"
//            self.commentStatus = Post.CommentStatus.close
//        }
//        
//        self.openInAppBrowser = openInAppBrowser
//        self.disableSharing = disableSharing
//        self.relatedPosts = relatedPosts
//        self.publishDate = publishDate
//	}
//	
//    
//    //conform to the CustomStringCovertiable Protocol
//    var description:String {
//        get {
//            return "->title: \(self.title)"
//        }
//    }
//}

