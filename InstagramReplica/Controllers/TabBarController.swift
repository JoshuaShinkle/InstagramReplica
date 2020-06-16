//
//  TabBarController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/9/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
        
    var user: User!
    let usersRef = Database.database().reference(withPath: "Online")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
          guard let user = user else { return }
          self.user = User(authData: user)
          // 1
          let currentUserRef = self.usersRef.child(self.user.uid)
          // 2
          currentUserRef.setValue(self.user.email)
          // 3
          currentUserRef.onDisconnectRemoveValue()
        }
    }
}
