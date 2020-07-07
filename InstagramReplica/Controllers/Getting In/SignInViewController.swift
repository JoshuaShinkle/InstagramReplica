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
          
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "signInToApp", sender: nil)
            }
        }
    }
        
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
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
