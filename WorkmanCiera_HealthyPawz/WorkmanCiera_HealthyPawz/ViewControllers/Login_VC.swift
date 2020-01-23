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
    
    let utilities = Utilities()
    
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
                    self.moveToHomeVC()
                }
            }
            
        }
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
        
        if utilities.isPasswordValid(userPassword) == false{
            
            return "Passwords must be 8 characters with 1 number and 1 special character."
        }
        return nil
    }
    
    func moveToHomeVC(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "toHome") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
