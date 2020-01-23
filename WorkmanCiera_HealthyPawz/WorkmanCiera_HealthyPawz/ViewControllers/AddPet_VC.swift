//
//  AddPet_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/22/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit

class AddPet_VC: UIViewController {

    //Outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Actions
    @IBAction func addPetTapped(_ sender: Any) {
        
    }
    
    //MARK: Helper Methods
    func validateFields(){
        
       
        
    }
    
    func moveToHomeVC(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "toHome") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
