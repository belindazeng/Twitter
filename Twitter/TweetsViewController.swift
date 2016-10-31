//
//  ViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets = [Tweet]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // so it resizes
        tableView.rowHeight = UITableViewAutomaticDimension
        // for the scrollbar
        tableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view, typically from a nib.
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            // populate tableview with tweets
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: {(error: Error) -> () in
            print(error.localizedDescription)
        })
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            // populate tableview with tweets
            self.tweets = tweets
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            
        }, failure: {(error: Error) -> () in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellTableViewCell") as! TweetCellTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }

    
//     MARK: - Navigation
//     
//     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            let detailViewController = segue.destination as! TweetDetailViewController
            
            detailViewController.tweet = tweet
            if let indexPath = indexPath {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        if let button = sender as? UIButton {
            // get the cell the button belongs to so we can pass the information
            if let view = button.superview {
                if let cell = view.superview as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    let tweet = tweets[(indexPath?.row)!]
                    print("getting to the button")
                    print(button)
                    let destinationNavigationController = segue.destination as! UINavigationController
                    let newTweetViewController = destinationNavigationController.topViewController as! NewTweetViewController
                    newTweetViewController.tweet = tweet
                }
            }
            
            
        }
     }
    
}

