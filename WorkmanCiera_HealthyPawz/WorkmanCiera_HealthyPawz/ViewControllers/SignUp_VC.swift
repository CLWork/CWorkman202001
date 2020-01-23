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

class SignUp_VC: UIViewController {

    //Outlets
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Variables
    let utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hides error label
        errorLabel.alpha = 0
        
        
    }
    
    // MARK: Actions
    
    //returns to landing screen
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    //takes user to Login screen without having the navigate backwards to landing screen.
    @IBAction func existingAccTapped(_ sender: Any) {
         performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    
    //signs up a user
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateTextFields()
        if error != nil{
            displayError(error!)
        }
        else{
            
            //force upwraped because of validate method will check for empty fields.
            let firstName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil{
                    //Handle error
                    self.displayError("Error in Creating User!")
                }
                
                else {
                    //User created
                    
                    self.performSegue(withIdentifier: "toAddPetsVC", sender: UIButton.self)
                }
            }
            //Move to Home Screen
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
        return nil
    }
    
    //shows errors to the user
    func displayError(_ errorMsg: String){
        errorLabel.text = errorMsg
        errorLabel.alpha = 1
    }
    
    //changes the root view controller in order to transition from login/sign-up to the home screen of the app.
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
