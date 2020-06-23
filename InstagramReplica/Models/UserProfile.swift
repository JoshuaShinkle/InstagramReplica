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
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
}
