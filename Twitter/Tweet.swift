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
    var dateStr: String?
    
    // var personallyRetweeted: Bool?
    
    
    func formatTimeToString(date: NSDate) -> String {
        let interval = date.timeIntervalSinceNow
        let intervalInt = Int(interval) * -1
        let days = (intervalInt / 3600) / 24
        if days != 0 {
            let daysStr = String(days) + "d"
            return daysStr
        }
        let hours = (intervalInt / 3600)
        if hours != 0 {
            return String(hours) + "h"
        }
        
        let minutes = (intervalInt / 60) % 60
        if minutes != 0 {
            return String(minutes) + "m"
        }
        
        let seconds = intervalInt % 60
        if seconds != 0 {
            return String(seconds) + "s"
        }
        else  {
           return "Now"
        }
    }
    
    init(dictionary: NSDictionary) {
        super.init()
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
        if timestamp != nil
        {
            self.dateStr = self.formatTimeToString(date: self.timestamp!)
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
