//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Archit Jain on 9/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let tweetsRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        tweetsRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = tweetsRefreshControl
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)!
        cell.profileImageView.af_setImage(withURL: imageUrl)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    @objc func loadTweets(){
        
        let tweetsUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = 20
        let tweetsParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsUrl, parameters: tweetsParams as [String : Any], success: {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.tweetsRefreshControl.endRefreshing()
            
        } , failure: {(Error) in
            print("Could not retrieve tweets")
        })
    }
    
    func loadMoreTweets(){
        let tweetsUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let tweetsParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsUrl, parameters: tweetsParams, success: {(tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        } , failure: {(Error) in
            print("Could not retrieve tweets")
        })
    }
    
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
}
