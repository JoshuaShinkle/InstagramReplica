//
//  DiscoverCell.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 7/7/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit

class DiscoverCell: UITableViewCell {
    
    var user: UserProfile? {
        didSet {
            guard let photoURL = user?.photoURL else { return }
            guard let username = user?.username else { return }
            
            ImageService.getImage(withURL: photoURL) { image, url in
                self.profileImageView.image = image
            }
            
            self.textLabel?.text = username
        }
    }

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48/2
        profileImageView.clipsToBounds = true
        
        self.textLabel?.text = "Username"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
