//
//  SignUp_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/21/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUp_VC: UIViewController {

    //Outlets
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    //Variables
    let utilities = Utilities()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
       
    }
    
    // MARK: Actions
    
    //takes user to Login screen without having the navigate backwards to landing screen.
    @IBAction func existingAccTapped(_ sender: Any) {
         performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    
    //signs up a user
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateTextFields()
        if error != nil{
            alert(error!)
        }
        else{
            
            //force upwraped because of validate method will check for empty fields.
            let fName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil{
                    //Handle error
                    self.alert("Unable to create new user, please try again.")
                }
                    
                else {
                    
                    //User has been created, now we're adding name info to the database via user ID.
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        
                        self.ref.child("users/\(uid)/firstName").setValue(fName)
                        self.ref.child("users/\(uid)/lastName").setValue(lName)
                        
                        self.performSegue(withIdentifier: "toAddPetVC", sender: UIButton.self)
                    } else{
                        
                        self.alert("Unable to add User's full name to profile.")
                    }
                }
            }
        }
        
    }
    
    // MARK: Helper Methods
    
    //validates all text fields.
    func validateTextFields() -> String?{
        if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please ensure all fields are not blank!"
        }
        
        let userPassword = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if utilities.isPasswordValid(userPassword) == false{
             return "Passwords must be 8 characters with 1 number and 1 special character."
        }
        
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if utilities.isEmailVallid(email) == false{
            return "Please make sure to use the valid email format: email@domain.com!"
        }
        return nil
    }
    
   //uses an alert window to notify the user about an error.
   func alert(_ message: String){
       let alert = UIAlertController(title: "Oops!", message: "\(message)", preferredStyle: .alert)
       let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alert.addAction(okButton)
       present(alert, animated: true, completion: nil)
       
   }

}
