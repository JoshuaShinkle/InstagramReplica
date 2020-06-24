//
//  Post.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/23/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import Foundation

class Post {
    var id: String
    var author: UserProfile
    var caption: String
    var createdAt: Date
    var location: String
    
    init(id: String, author: UserProfile, caption: String, location: String, timestamp: Double) {
        self.id = id
        self.author = author
        self.caption = caption
        self.location = location
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
}
