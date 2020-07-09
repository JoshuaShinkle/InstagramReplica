//
//  UserAuth.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/8/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import Foundation
import Firebase

struct UserAuth {
    
    let uid: String
    let email: String
  
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
      
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
