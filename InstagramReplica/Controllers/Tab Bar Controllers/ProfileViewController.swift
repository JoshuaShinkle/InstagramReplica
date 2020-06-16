//
//  ProfileViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/9/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        // sign out
        let user = Auth.auth().currentUser
        let onlineRef = Database.database().reference(withPath: "online/\(String(describing: user?.uid))")
        
        onlineRef.removeValue { (error, _) in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
}
