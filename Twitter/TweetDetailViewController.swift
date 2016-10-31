//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    // navigation related
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    // view related
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let text = tweet.text {
            textLabel.text = text as String
        }
        if let profileImageUrl = tweet.user?.profileUrl {
            profileImageView.setImageWith(profileImageUrl as URL)
        }
        
        if (tweet.user?.screenName) != nil {
            screenNameLabel.text = tweet.user?.screenName as String?
        }
        favoriteCountLabel.text = String(tweet.favoritesCount)
        retweetCountLabel.text = String(tweet.retweetCount)
        
        if let date = tweet.timestamp {
            dateLabel.text = String(describing: date)
        }
        
    }
    @IBAction func onRetweetButton(_ sender: Any) {
        if let id = tweet.id {
            TwitterClient.sharedInstance.retweet(id: id as String, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.retweetCountLabel.text = String(tweet.retweetCount)
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
