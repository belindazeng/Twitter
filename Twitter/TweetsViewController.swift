//
//  ViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/29/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit


extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NewTweetViewControllerDelegate {
    var tweets = [Tweet]()
    
    let DEFAULT_NUM_TWEETS = "20"
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
        TwitterClient.sharedInstance.homeTimeline(count: DEFAULT_NUM_TWEETS, success: { (tweets: [Tweet]) in
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
        
        // setup infinte scroll view
        setupInfiniteScrollView()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(count: DEFAULT_NUM_TWEETS, success: { (tweets: [Tweet]) in
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
    
    // swipe action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCellTableViewCell") as! TweetCellTableViewCell
            let tweet = self.tweets[indexPath.row]
            
            
            // remove from our array immediately
            self.tweets.remove(at: indexPath.row)
            
            tableView.reloadData()
            if let tweetId = tweet.id as? String {
                TwitterClient.sharedInstance.deleteTweet(id: tweetId, success: {(tweet: Tweet) -> () in
                }, failure: { (error: Error) in
                    
                })
            }
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
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
                    let destinationNavigationController = segue.destination as! UINavigationController
                    let newTweetViewController = destinationNavigationController.topViewController as! NewTweetViewController
                    newTweetViewController.delegate = self
                    newTweetViewController.tweet = tweet
                }
            }
            
            
        }
     }
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    func setupInfiniteScrollView() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    // scroll related functions
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(tableView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    @IBAction func onAddButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationNavigationController = storyboard.instantiateViewController(withIdentifier: "NewTweetNavigationController") as! UINavigationController
        let newTweetViewController = destinationNavigationController.topViewController as! NewTweetViewController
        newTweetViewController.delegate = self
        self.present(destinationNavigationController, animated: true, completion: nil)
    }
    
    func loadMoreData() {
        let count = tweets.count
        let newCount = String(count + 20)
        TwitterClient.sharedInstance.homeTimeline(count: newCount, success: { (tweets: [Tweet]) in
            // populate tableview with tweets
            self.tweets = tweets
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
        }, failure: {(error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    // delegate function 
    func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateTweet value: Tweet) {
        print("getting here")
        tweets.insert(value, at: 0)
        tableView.reloadData()
    }
    
}

