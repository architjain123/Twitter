//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Archit Jain on 9/20/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    
    var profile = NSDictionary()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileData()
    }
    
    func loadProfileData(){
        TwitterAPICaller.client?.getProfileDetails(success: {(profile:NSDictionary) in
            print("Retrieved profile data")
            self.profile = profile
            self.displayProfile()
        }, failure: { (Error) in
            print("Error retreiving profile data: \(Error)")
        })
    }
    
    func displayProfile(){
        print(profile)
        nameLabel.text = self.profile["name"] as? String
        screenNameLabel.text = "@" + ((self.profile["screen_name"] as? String)!)
        descriptionLabel.text = self.profile["description"] as? String
        followingLabel.text = "\(self.profile["friends_count"] as? Int ?? 0)"
        followersLabel.text = "\(self.profile["followers_count"] as? Int ?? 0)"
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.af_setImage(withURL: URL(string: profile["profile_image_url_https"] as! String)!)

    }

}
