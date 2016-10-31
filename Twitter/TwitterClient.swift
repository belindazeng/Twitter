//
//  TwitterClient.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance : TwitterClient = TwitterClient(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "17mu0YBdAu21owZZ6M2YQGVMB", consumerSecret: "jUrdLKuGxfHBHnrQcEZ7h7b2f1mdKEf9MclO9icwMxkqosAY0V")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        // get authorization to send user to url
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterdemo://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            if let token = requestToken?.token {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url)
            }
        }, failure: {(error: Error?) -> Void in
            if let error = error {
                    self.loginFailure?(error)
            }
        })
    }
    
    func handleOpenUrl(url: URL) {
        // get user info
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            print("I got an access token")
            self.loginSuccess?()
            
            TwitterClient.sharedInstance.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            //
            TwitterClient.sharedInstance.homeTimeline(count: "20", success: { (tweets: [Tweet]) in
                print(tweets)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            
        }, failure: {(error: Error?) -> Void in
            print(error?.localizedDescription ?? "")
            if let error = error {
                self.loginFailure?(error)
            }
        })
    }
    
    func homeTimeline(count: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: ["count": count], progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let tweetsDictionary = response as? [NSDictionary] {
                let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionary)
                success(tweets)
            }
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let userDictionary = response as? NSDictionary {
                let user = User(dictionary: userDictionary)
                success(user)
            }
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func deleteTweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/statuses/destroy/" + id + ".json"
        post(url, parameters: nil, progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let responseDictionary = response as? NSDictionary {
                let tweet = Tweet(dictionary: responseDictionary
                )
                success(tweet)
            }}, failure: { (_: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
        
    }
    
    func retweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/statuses/retweet/" + id + ".json"
        post(url, parameters: nil, progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let responseDictionary = response as? NSDictionary {
                let tweet = Tweet(dictionary: responseDictionary
                )
                success(tweet)
            }}, failure: { (_: URLSessionDataTask?, error: Error) in
                print(error)
            failure(error)
        })

    }
    
    func unretweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/statuses/unretweet/" + id + ".json"
        post(url, parameters: nil, progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let responseDictionary = response as? NSDictionary {
                let tweet = Tweet(dictionary: responseDictionary
                )
        
                success(tweet)
            }}, failure: { (_: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
        
    }
    
    
    func favorite(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/favorites/create.json"
        post(url, parameters: ["id": id], progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let responseDictionary = response as? NSDictionary {
                let tweet = Tweet(dictionary: responseDictionary
                )
                print(tweet.favoritesCount)
                print(tweet.retweetCount)
                success(tweet)
            }}, failure: { (_: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
        
    }
    
    func unfavorite(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let url = "1.1/favorites/destroy.json"
        post(url, parameters: ["id": id], progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let responseDictionary = response as? NSDictionary {
                let tweet = Tweet(dictionary: responseDictionary
                )
                
                success(tweet)
            }}, failure: { (_: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
        
    }
    
    func createTweet(in_reply_to_status_id: NSString?, status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        // POST https://api.twitter.com/1.1/statuses/update.json?status=Maybe%20he%27ll%20finally%20find%20his%20keys.%20%23peterfalk
        
        
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        print(url)
        
        // set the reply id automatically if there is one
        var parameters = ["status": status]
        if let in_reply_to_status_id_string =  in_reply_to_status_id {
            parameters["in_reply_to_status_id"] =  in_reply_to_status_id_string as String
        }
        post(url, parameters: parameters, progress: nil, success: { (_:  URLSessionDataTask, response: Any?) -> Void in
            if let responseDictionary = response as? NSDictionary {
                let tweet = Tweet(dictionary: responseDictionary
                )
                success(tweet)
            }}, failure: { (_: URLSessionDataTask?, error: Error) in
                print(error)
                failure(error)
        })
        
    }

    
    
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
}
