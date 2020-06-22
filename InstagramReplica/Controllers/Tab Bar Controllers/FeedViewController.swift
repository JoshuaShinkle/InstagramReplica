//
//  FeedViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/9/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

let ref = Database.database().reference()
var postNumber = 0
var cellNumber = 0

class FeedViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 250
        
        ref.child("User").child("Number of Posts").observe(.value, with: { snapshot in
            postNumber = snapshot.value as? Int ?? 0
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postNumber
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellNumber == 0 {
            cellNumber = postNumber
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell

        if postNumber != 0 {
            let yourImage: UIImage = UIImage(named: "test")!
            cell.profileImage.image = yourImage
            cell.profileImage.makeRounded()
                
            ref.child("User").child("Post \(cellNumber)").child("Name").observe(.value, with: { snapshot in
                let name = snapshot.value
                cell.fullNameLabel.text = String(describing: name!)
            })

            ref.child("User").child("Post \(cellNumber)").child("Caption").observe(.value, with: { snapshot in
                let caption = snapshot.value
                cell.captionLabel.text = String(describing: caption!)
            })
        }
        else {
            cell.fullNameLabel.text = ""
            cell.captionLabel.text = ""
        }
        
        if cellNumber > 0 {
            cellNumber -= 1
        }
        
        return cell
    }
}
