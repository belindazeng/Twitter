//
//  User.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var headerUrl: NSURL?
    var tweetCount: NSString?
    var followerCount: NSString?
    var followingCount: NSString?
    
    static let userDidLogoutNotification = "userDidLogout"
    
    init(dictionary:NSDictionary) {
        // deserialization
        self.dictionary = dictionary
        name = dictionary["name"] as? NSString
        screenName = dictionary["screen_name"] as? NSString
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? NSString
        
        // verify the get
        let headerUrlString = dictionary["profile_background_image_url_https"] as? String
        if let headerUrlString = headerUrlString {
            headerUrl = NSURL(string: headerUrlString)
        }
//        print(dictionary["followers_count"])
        if let followerCount = dictionary["followers_count"] {
            self.followerCount = String(describing: followerCount) as NSString
        }
        if let followingCount = dictionary["friends_count"] {
            self.followingCount = String(describing: followingCount) as NSString
        }
        if let tweetCount = dictionary["listed_count"] {
            self.tweetCount = String(describing: tweetCount) as NSString
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: "currentUser") as? Data {
                    print(userData)
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    self._currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
            
        }
    }
    
    
}
