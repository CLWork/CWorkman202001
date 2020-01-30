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

    let utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    //authenticates user
    @IBAction func loginTapped(_ sender: Any) {
        
        let error = validateTextFields()
        if error != nil{
            
            //unwrapping error because it has already been nil checked!
            alert(error!)
            
        } else{
            
           let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    self.alert("Unable to sign in.")
                }
                
                else {
                    //Transition!
                    self.moveToHomeVC()
                }
            }
            
        }
    }
    
    //takes user to sign up page when they click the Sign Up button at the bottom of the page.
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
        
        if utilities.isPasswordValid(userPassword) == false{
            
            return "Passwords must be 8 characters with 1 number and 1 special character."
        }
        
        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if utilities.isEmailVallid(email) == false{
            return "Please make sure to use the valid email format: email@domain.com!"
        }
        
        return nil
    }
    
    //changes root controller to tab bar controller.
    func moveToHomeVC(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "toHome") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    //uses an alert window to notify the user about an error.
    func alert(_ message: String){
        let alert = UIAlertController(title: "Oops!", message: "\(message)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }

}
