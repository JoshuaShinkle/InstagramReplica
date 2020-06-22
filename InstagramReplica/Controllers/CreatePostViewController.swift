//
//  CreatePostViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/12/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController, UITextViewDelegate {
        
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var captionText: UITextView!
    @IBOutlet var profileImage: UIImageView!
    
    var postNum = 0
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionText.delegate = self
        captionText.textColor = UIColor.lightGray
        
        let yourImage: UIImage = UIImage(named: "test")!
        profileImage.image = yourImage
        profileImage.makeRounded()
        
        ref.child("User").child("Name").observe(.value, with: { snapshot in
            let name = snapshot.value
            self.fullNameLabel.text = String(describing: name!)
            if self.fullNameLabel.text == "<null>" {
                self.fullNameLabel.text = ""
            }
        })
        
        ref.child("User").child("Number of Posts").observe(.value, with: { snapshot in
            let num = snapshot.value
            self.postNum = (num as? Int ?? 0) + 1
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if captionText.textColor == UIColor.lightGray {
            captionText.text = nil
            captionText.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if captionText.text.isEmpty {
            captionText.text = "Placeholder"
            captionText.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func post (_ sender: AnyObject) {
        ref.child("User").child("Number of Posts").setValue(postNum)
        
        ref.child("User").child("Post \(postNum)").child("Name").setValue(fullNameLabel.text)
        ref.child("User").child("Post \(postNum)").child("Caption").setValue(captionText.text)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarController
                self.present(TabBarViewController, animated: true, completion: nil)
    }
}

extension UIImageView {

    func makeRounded() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
