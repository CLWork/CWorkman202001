//
//  Settings_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/29/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit
import FirebaseAuth

class Settings_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Allows user to logout of the app and takes them back to the login/sign-up screen
    @IBAction func logoutTapped(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "backToLanding", sender: UIButton.self)
            
        } catch _{
            
            alert("Unable to logout at this time, please try again!")
        }
        

    }
    
    //lets the user know something is wrong.
       func alert(_ message: String){
           let alert = UIAlertController(title: "Oops!", message: "\(message)", preferredStyle: .alert)
           let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alert.addAction(okButton)
           present(alert, animated: true, completion: nil)
           
       }
    
}
