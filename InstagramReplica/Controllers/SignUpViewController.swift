//
//  SignUpViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/8/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    let signInToApp = "signInToApp"
      
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.signInToApp, sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
                self.fullNameField.text = nil
                self.phoneNumberField.text = nil
            }
        }
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.emailField.text!,
                                   password: self.passwordField.text!)
            }
        }
        ref.child("User").child("Name").setValue(fullNameField.text)
    }
}
