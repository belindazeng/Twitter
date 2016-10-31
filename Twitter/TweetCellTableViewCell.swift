//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCellTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    
    let retweetColor = UIColor(red: 102/255, green: 199/255, blue: 132/255, alpha: 1)
    let starColor = UIColor(red: 207/255, green: 69/255, blue: 88/255, alpha: 1)
    let replyColor = UIColor(red: 0/255, green: 132/255, blue: 180/255, alpha: 1)
    
    var tweet: Tweet! {
        didSet {
            if let text = tweet.text {
                taglineLabel.text = text as String
            }
            if let profileImageUrl = tweet.user?.profileUrl {
                profileImageView.setImageWith(profileImageUrl as URL)
            }
            
            if (tweet.user?.screenName) != nil {
                screenNameLabel.text = tweet.user?.screenName as String?
            }
 
            starCountLabel.text = String(tweet.favoritesCount)
            retweetCountLabel.text = String(tweet.retweetCount)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if retweetButton.currentBackgroundImage == #imageLiteral(resourceName: "retweet") {
            if let id = tweet.id {
                TwitterClient.sharedInstance.retweet(id: id as String, success: { (tweet: Tweet) in
                    self.retweetCountLabel.text = String(tweet.retweetCount)
                }, failure: {(error: Error) -> () in
                    print(error)
                })
            }
            // change the color of the UI
            retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet_colored"), for: .normal)
            retweetCountLabel.textColor = retweetColor
        }
        else {
            self.unretweet()
        }
    }
    
    func unretweet() {
        if let id = tweet.id {
            TwitterClient.sharedInstance.unretweet(id: id as String, success: { (tweet: Tweet) in
                self.retweetCountLabel.text = String(self.tweet.retweetCount)
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
        }
        // change the color of the UI
        // change the color of the UI
        retweetButton.setBackgroundImage(#imageLiteral(resourceName: "retweet"), for: .normal)
        retweetCountLabel.textColor = UIColor.black
    }
    
    
    @IBAction func onHeartButton(_ sender: Any) {
        if starButton.currentBackgroundImage == #imageLiteral(resourceName: "heart") {
            if let id = tweet.id {
                TwitterClient.sharedInstance.favorite(id: id as String, success: { (tweet: Tweet) in
                    print(tweet.favoritesCount)
                    self.starCountLabel.text = String(tweet.favoritesCount)
                }, failure: {(error: Error) -> () in
                    print(error)
                })
            }
            // change the color of the UI
            starButton.setBackgroundImage(#imageLiteral(resourceName: "heart_colored"), for: .normal)
            starCountLabel.textColor = starColor
        }
        else {
            self.unfavorite()
        }

    }
    
    func unfavorite() {
        if let id = tweet.id {
            TwitterClient.sharedInstance.unfavorite(id: id as String, success: { (tweet: Tweet) in
                self.starCountLabel.text = String(self.tweet.favoritesCount)
            }, failure: {(error: Error) -> () in
                print(error.localizedDescription)
            })
        }
        // change the color of the UI
        // change the color of the UI
        starButton.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
        starCountLabel.textColor = UIColor.black
    }
    
    

}
