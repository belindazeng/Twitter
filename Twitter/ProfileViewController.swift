//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 10/30/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        var name: NSString?
//        var screenName: NSString?
//        var profileUrl: NSURL?
//        var tagline: NSString?
        
        if let imageUrl = User.currentUser?.profileUrl {
            profileImageView.setImageWith(imageUrl as URL)
        }
        if let name = User.currentUser?.name {
            nameLabel.text = name as String
        }
        if let tagline = User.currentUser?.tagline {
            taglineLabel.text = tagline as String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
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
