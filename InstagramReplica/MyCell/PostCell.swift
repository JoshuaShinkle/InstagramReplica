//
//  PostCell.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/23/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var post: Post?
    
    func set(post: Post) {
        self.post = post
        self.profileImage.image = nil
        ImageService.getImage(withURL: post.author.photoURL) { image, url in
            guard let _post = self.post else {return}
            if _post.author.photoURL.absoluteString == url.absoluteString {
                self.profileImage.image = image
            }
        }
        
        usernameLabel.text = post.author.username
        captionLabel.text = post.caption
        locationLabel.text = post.location
        timeLabel.text = post.createdAt.calenderTimeSinceNow()
    }
}
