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
        
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!

    var user: User!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionText.delegate = self
        captionText.textColor = UIColor.lightGray
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let usersRef = Database.database().reference(withPath: "users")
            usersRef.child("\(user.uid)").child("photoURL").observe(.value, with: { snapshot in
                let url = snapshot.value as? String
                let photoURL = URL(string: url  ?? "http://www.example.com/image.jpg")!
                ImageService.getImage(withURL: photoURL) { image in
                    self.profileImage.image = image
                }
            })
        }
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let usersRef = Database.database().reference(withPath: "users")
            usersRef.child("\(user.uid)").child("username").observe(.value, with: { snapshot in
                let name = snapshot.value
                self.usernameLabel.text = String(describing: name!)
            })
        }
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
        
        guard let userProfile = UserService.currentUserProfile else {return}

        let postRef = Database.database().reference().child("posts").child("\(Date())")
        
        let postObject = [
            "author" : [
                "uid" : userProfile.uid,
                "username" : userProfile.username,
                "photoURL" : userProfile.photoURL.absoluteString
            ],
            "caption" : captionText.text ?? "",
            "timestamp" : [".sv" : "timestamp"]
        ] as [String:Any]
        
        postRef.setValue(postObject)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarController
        self.present(TabBarViewController, animated: true, completion: nil)
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
