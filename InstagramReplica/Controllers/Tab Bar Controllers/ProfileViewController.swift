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
    
    var user: User!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let usersRef = Database.database().reference(withPath: "users")
            usersRef.child("\(user.uid)").child("photoURL").observe(.value, with: { snapshot in
                let url = snapshot.value as? String
                let photoURL = URL(string: url  ?? "http://www.example.com/image.jpg")!
                ImageService.getImage(withURL: photoURL) { image, url in
                    self.profileImage.image = image
                }
            })
        }

        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
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
    
    @IBAction func changeProfileImage(_ sender: AnyObject) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url: URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func saveProfile(username:String, profileImageURl: URL, completion: @escaping ((_ success: Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("users/\(uid)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURl.absoluteString
        ] as [String:Any]
        
        databaseRef.setValue(userObject) {error, ref in
            completion(error == nil)
        }
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        let user = Auth.auth().currentUser
        let onlineRef = Database.database().reference(withPath: "online/\(String(describing: user?.uid))")
        
        onlineRef.removeValue { (error, _) in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
            do {
                try Auth.auth().signOut()
                //self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let WelcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
//        self.present(WelcomeViewController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        
        guard let image = profileImage.image else {return}
        guard let username = usernameLabel.text else {return}
        
        self.uploadProfileImage(image) { url in
            if url != nil {
                self.saveProfile(username: username, profileImageURl: url!) { success in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                //error
            }

        }
        //picker.dismiss(animated: true, completion: nil)
    }
}
