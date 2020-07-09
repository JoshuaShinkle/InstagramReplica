//
//  DiscoverVC.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 7/7/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "DiscoverUserCell"

class DiscoverVC: UITableViewController {
    
    var users = [UserProfile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DiscoverCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        fetchUsers()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        profileVC.userFromDiscover = user
        
        navigationController?.pushViewController(profileVC, animated: true)
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DiscoverCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string: photoURL) {
                let user = UserProfile(uid: snapshot.key, username: username, photoURL: url)
                self.users.append(user)
            }
            self.tableView.reloadData()
        }
    }
}

