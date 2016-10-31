//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/30/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit
import AFNetworking

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charactersLeftLabel: UILabel!
    
    let TWEET_MAX_LENGTH = 140
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let imageUrl = User.currentUser?.profileUrl as? URL {
            profileImageView.setImageWith(imageUrl)
        }
        if let screenName = User.currentUser?.screenName as? String {
            screenNameLabel.text = screenName
        }
        print(tweetTextView.text)
        tweetTextView.text = ""
        
        tweetTextView.delegate = self
        
        // if we came from a reply, prepopulate author
        if let tweet = self.tweet {
            print("getting here")
            if let name = tweet.user?.screenName as? String {
                tweetTextView.text = "@" + name + " "
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onReplyButton(_ sender: Any) {
        if let text = tweetTextView.text as? String {
            let tweet_id = self.tweet?.id ?? nil
            TwitterClient.sharedInstance.createTweet(in_reply_to_status_id: tweet_id,status: text, success: { (tweet: Tweet) in
                print("successfully created tweet!")
                }, failure: {(error: Error) -> () in
                    print(error.localizedDescription)
            })
            
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newLength = 0
        if let text = textView.text?.utf16 {
            let count = text.count
        
            newLength = count + 1
                
            //you can save this value to a global var
            //myCounter = newLength
            //return true to allow the change, if you want to limit the number of characters in the text field use something like
            // To just allow up to 25 characters
            //        return true
            
            charactersLeftLabel.text =  String(newLength) + "/140"
            
            if newLength == TWEET_MAX_LENGTH {
                charactersLeftLabel.textColor = UIColor.red
            }
        }
        return newLength < TWEET_MAX_LENGTH
    }
}
