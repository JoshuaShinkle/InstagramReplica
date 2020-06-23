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
    var author: String
    var caption: String
    
    init(id: String, author: String, caption: String) {
        self.id = id
        self.author = author
        self.caption = caption
    }
}
