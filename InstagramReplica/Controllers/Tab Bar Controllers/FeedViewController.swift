//
//  FeedViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/9/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UITableViewController {
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 250
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ref.child("User").child("Number of Posts").observe(.value, with: { snapshot in
            let postNumber = snapshot.value
        })
        return 1//postNumber
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        ref.child("User").child("Number of Posts").observe(.value, with: { snapshot in
            let postNumber = snapshot.value
            if (postNumber as? Int) != 0 {
                
                let yourImage: UIImage = UIImage(named: "test")!
                cell.profileImage.image = yourImage
                cell.profileImage.makeRounded()
                
                self.ref.child("User").child("Post 1").child("Name").observe(.value, with: { snapshot in
                    let name = snapshot.value
                    cell.fullNameLabel.text = String(describing: name!)
                })

                self.ref.child("User").child("Post 1").child("Caption").observe(.value, with: { snapshot in
                    let caption = snapshot.value
                    cell.captionLabel.text = String(describing: caption!)
                    /*if self.captionLabel.text == "<null>" {
                        self.captionLabel.text = ""
                    }*/
                })
            }
            else {
                cell.fullNameLabel.text = ""
                cell.captionLabel.text = ""
            }
        })
        return cell
    }
}
