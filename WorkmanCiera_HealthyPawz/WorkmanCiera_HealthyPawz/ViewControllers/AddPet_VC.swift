//
//  AddPet_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/22/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit

class AddPet_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {

    //Outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var petImageView: UIImageView!
    
    //Variables
    let imagePicker = UIImagePickerController()
    var breedArray = [String]()
    var selectedBreed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //allows user to tap image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        petImageView.addGestureRecognizer(tap)
        
        breedArray = ["Cat", "Dog", "Bird", "Rabbit", "Rodent", "Ferret"]
        
        
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    //MARK: Actions
    @IBAction func addPetTapped(_ sender: Any) {
        
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("No saved photos available.")
        }
    }
    
    //MARK: Helper Methods
    func validateFields(){
        
       
        
    }
    
    //Changes root controller so the authenticated user gets access to the full app.
    func moveToHomeVC(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "toHome") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
     //MARK: Protocols
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               petImageView.contentMode = .scaleAspectFit
               petImageView.image = pickedImage
           }
        
           dismiss(animated: true, completion: nil)
    }
    
    //dismisses image picker when cancel is pressed.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //tells picker view how many columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //tells picker how many rows in each column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breedArray.count
    }
    
    //pulls title for selected row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breedArray[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBreed = breedArray[row]
        print(selectedBreed)
    }
}
