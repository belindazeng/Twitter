//
//  Tweet.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var userImage: UIImage?
    var name: NSString?
    var id: NSString?
    // var personallyRetweeted: Bool?
    
    
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? NSString
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        if let userData = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userData)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet =
                Tweet.init(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    
}
