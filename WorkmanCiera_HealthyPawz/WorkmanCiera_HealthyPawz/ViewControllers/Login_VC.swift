//
//  Login_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/21/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class Login_VC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hides error label
        errorLabel.alpha = 0
        
    }
    // MARK: Actions
    @IBAction func loginTapped(_ sender: Any) {
        
        let error = validateTextFields()
        if error != nil{
            
        } else{
            
           let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                
                else {
                    //Transition!
                    
                }
            }
            
        }
    }
    
    //return user back to landing page.
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    
    //takes user to sign up page
    @IBAction func noAccountSignUpBttnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    // MARK: Helper Methods
    
    //ensures all text fields are filled and the password is valid.
    func validateTextFields() -> String?{
        
        if emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Fields cannot be blank!"
        }
        let userPassword = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(userPassword) == false{
            
            return "Passwords must be 8 characters with 1 number and 1 special character."
        }
        return nil
    }
    
    //ensures password is valid and secure enough by requiring a length of 8, special character, and a number.
    func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
