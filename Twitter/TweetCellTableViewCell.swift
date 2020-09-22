//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Archit Jain on 9/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var favourited: Bool = false
    var tweetId: Int = -1
    var retweeted: Bool = false
    
    @IBAction func onFavourite(_ sender: Any) {
        if (!favourited){
            TwitterAPICaller.client?.favouriteTweet(tweetId: tweetId, success: {
                self.setFavourite(true)
            }) { (Error) in
                print("Favourite failed: \(Error)")
            }
        }
        else{
            TwitterAPICaller.client?.unfavouriteTweet(tweetId: tweetId, success: {
                self.setFavourite(false)
            }) { (Error) in
                print("Unfavourite failed: \(Error)")
            }
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (Error) in
            print("Retweeting failed \(Error)")
        })
    }
    
    func setFavourite(_ isFavourited: Bool){
        favourited = isFavourited
        if (isFavourited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool){
        if (isRetweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
