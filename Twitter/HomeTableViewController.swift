//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Archit Jain on 9/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let tweetsRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = tweetsRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as! String))!
        let data = try? Data(contentsOf: imageUrl)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.timeLabel.text = getRelativeTime(timeString: tweetArray[indexPath.row]["created_at"] as! String)
        
        cell.setFavourite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
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
    
    func getRelativeTime(timeString: String) -> String{
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
                return "\(secondsAgo)s"
            } else if secondsAgo < hour {
                return "\(secondsAgo / minute)m"
            } else if secondsAgo < day {
                return "\(secondsAgo / hour)h"
            } else if secondsAgo < week {
                return "\(secondsAgo / day)d"
            }
        return "\(secondsAgo / week)w"
    }
}
