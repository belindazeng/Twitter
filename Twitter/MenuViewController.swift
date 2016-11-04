//
//  HamburgerTableViewController.swift
//  Twitter
//
//  Created by Belinda Zeng on 11/4/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var options = [String]()
    var viewControllers = [UIViewController]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.delegate = self
        tableView.dataSource = self
        
        // set options 
        options = ["Tweets", "Profile"]
        tableView.reloadData()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        viewControllers.append(tweetsNavigationController)
        
        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        viewControllers.append(profileNavigationController)
        
        hamburgerViewController.contentViewController = tweetsNavigationController
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerOptionTableViewCell") as! HamburgerOptionTableViewCell
        cell.option = options[indexPath.row] as NSString?
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return options.count
    }

   

}
