//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Furkan Deniz Albaylar on 8.09.2023.
//

import UIKit
import FirebaseAuth
import Firebase

class SignViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let gestureRecongnizer = UIGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(gestureRecongnizer)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }


    @IBAction func signInButtonClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text ?? "", password: passwordText.text ?? "") { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                    
                } else {
                    self.performSegue(withIdentifier: "toListVC", sender: nil)
                }
            }
            
            
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text ?? "", password: passwordText.text ?? "") { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                    
                } else {
                    self.performSegue(withIdentifier: "toListVC", sender: nil)
                }
            }
            
            
        }
    }
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}

