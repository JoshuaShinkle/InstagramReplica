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
        
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!

    var user: User!
    var imagePicker: UIImagePickerController!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        captionText.delegate = self
        captionText.textColor = UIColor.lightGray
        
        let yourImage: UIImage = UIImage(named: "test")!
        profileImage.image = yourImage
        profileImage.makeRounded()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let usersRef = Database.database().reference(withPath: "Users")
            usersRef.child("\(user.uid)").child("Name").observe(.value, with: { snapshot in
                let name = snapshot.value
                self.nameLabel.text = String(describing: name!)
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
        
        let postRef = Database.database().reference().child("Posts").child("\(Date())")
        
        let postObject = [
            "caption" : captionText.text ?? "",
            "timestamp" : [".sv" : "timestamp"]
        ] as [String:Any]
        
        postRef.setValue(postObject)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TabBarViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarController
                self.present(TabBarViewController, animated: true, completion: nil)
    }
    
    @IBAction func insertImage (_ sender: AnyObject) {
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension UIImageView {

    func makeRounded() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.postImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
