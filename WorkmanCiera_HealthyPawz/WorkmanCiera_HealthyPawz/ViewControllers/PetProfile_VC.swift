//
//  PetProfile_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 2/2/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit

class PetProfile_VC: UIViewController {
    //Outlets
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petWeight: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    //Variables
    var selectedPet: Pets?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        populateProfile()
    }
    
    func populateProfile(){
        
        if selectedPet != nil{
            self.title = selectedPet?.name
            petImage.image = selectedPet?.image
            petAge.text = selectedPet?.age
            petWeight.text = "\(selectedPet?.weight ?? "20")lb"
            speciesLabel.text = selectedPet?.species
            genderLabel.text = selectedPet?.gender
        } else{
            print("Error in loading pet profile.")
        }
        
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
