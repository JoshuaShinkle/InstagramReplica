//
//  FeedViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/9/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
        
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var newsFeed: UITableView!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        func newsFeed(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            print("yellow")
            cell.fullNameLabel.text = "it works!"

            return cell
        }
        
        ref.child("User").child("Number of Posts").observe(.value, with: { snapshot in
            let postNum = snapshot.value
            if (postNum as? Int ?? 0) != 0 {
                
                let yourImage: UIImage = UIImage(named: "test")!
                self.profileImage.image = yourImage
                self.profileImage.makeRounded()
                
                self.ref.child("User").child("Post 1").child("Name").observe(.value, with: { snapshot in
                    let name = snapshot.value
                    self.fullNameLabel.text = String(describing: name!)
                    if self.fullNameLabel.text == "<null>" {
                        self.fullNameLabel.text = ""
                    }
                })

                self.ref.child("User").child("Post 1").child("Caption").observe(.value, with: { snapshot in
                    let caption = snapshot.value
                    self.captionLabel.text = String(describing: caption!)
                    if self.captionLabel.text == "<null>" {
                        self.captionLabel.text = ""
                    }
                })
            }
            else {
                /*self.fullNameLabel.text = ""
                self.captionLabel.text = ""*/
            }
        })
    }
}
