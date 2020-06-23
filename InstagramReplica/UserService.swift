//
//  UserService.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/23/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile: UserProfile?
    
    static func observeUserProfile(_ uid: String, completion: @escaping ((_ userProfile: UserProfile?)->())) {
        let userRef = Database.database().reference().child("users").child("\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile: UserProfile?
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String {
                userProfile = UserProfile(uid: snapshot.key, username: username)
            }
            completion(userProfile)
        })
    }
}
