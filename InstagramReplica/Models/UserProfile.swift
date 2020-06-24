//
//  UserProfile.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/23/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import Foundation

class UserProfile {
    
    var uid: String
    var username: String
    var photoURL: URL
    
    init(uid: String, username: String, photoURL: URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
