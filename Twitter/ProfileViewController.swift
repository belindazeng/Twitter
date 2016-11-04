//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/30/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var user: User?
    var tweets = [Tweet]()
    let DEFAULT_NUM_TWEETS = "20"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        var name: NSString?
//        var screenName: NSString?
//        var profileUrl: NSURL?
//        var tagline: NSString?
        if user == nil {
            user = User.currentUser
        }
        
        if let imageUrl = user?.profileUrl {
            profileImageView.setImageWith(imageUrl as URL)
        }
        if let headerImageUrl = user?.headerUrl {
            headerImageView.setImageWith(headerImageUrl as URL)
        }
        if let name = user?.name {
            nameLabel.text = name as String
        }
        if let tagline = user?.tagline {
            taglineLabel.text = tagline as String
        }
        if let tweetCount = user?.tweetCount as? String {
            print(tweetCount)
            tweetCountLabel.text = tweetCount
        }
        if let followerCount = user?.followerCount as? String {
            followerCountLabel.text = followerCount
        }
        if let followingCount = user?.followingCount as? String {
            followerCountLabel.text = followingCount
        }
        
        // table view settings
        // so it resizes
        tableView.rowHeight = UITableViewAutomaticDimension
        // for the scrollbar
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        // ProfileTimelineCell
        
        // substitute later with different call
        TwitterClient.sharedInstance.homeTimeline(count: DEFAULT_NUM_TWEETS, success: { (tweets: [Tweet]) in
            // populate tableview with tweets
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: {(error: Error) -> () in
            print(error.localizedDescription)
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellTableViewCell") as! TweetCellTableViewCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
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
