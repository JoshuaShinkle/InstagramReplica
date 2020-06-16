//
//  SignInViewController.swift
//  InstagramReplica
//
//  Created by Joshua Shinkle on 6/8/20.
//  Copyright © 2020 shinkle. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    let signInToApp = "signInToApp"
      
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.signInToApp, sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
        
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            email.count > 0,
            password.count > 0
            else {
                return
            }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
