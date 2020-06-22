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
    var fullName = "Placeholder"
    let onlineRef = Database.database().reference(withPath: "Online")
    let usersRef = Database.database().reference(withPath: "Users")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.onlineRef.child(self.user.uid)
            if self.fullName != "Placeholder" {
                self.usersRef.child("\(self.user.uid)").child("Name").setValue(self.fullName)
            }
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
}
