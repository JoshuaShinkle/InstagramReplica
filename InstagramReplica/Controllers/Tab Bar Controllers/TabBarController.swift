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
        
    var user: UserAuth!
    var username = "Placeholder"
    let onlineRef = Database.database().reference(withPath: "online")
    let usersRef = Database.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = UserAuth(authData: user)
            let currentUserRef = self.onlineRef.child(self.user.uid)
            if self.username != "Placeholder" {
                self.usersRef.child("\(self.user.uid)").child("username").setValue(self.username)
            }
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
}
