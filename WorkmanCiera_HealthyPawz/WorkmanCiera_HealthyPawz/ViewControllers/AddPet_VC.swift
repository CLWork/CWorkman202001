//
//  AddPet_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/22/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddPet_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {

    //Outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    //Variables
    let imagePicker = UIImagePickerController()
    var breedArray = [String]()
    var selectedBreed = ""
    var genderArray = [String]()
    var selectedGender = ""
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference database
        ref = Database.database().reference()
        
        //Populate arrays for the picker
        breedArray = ["Breed:","Cat", "Dog", "Bird", "Rabbit", "Rodent", "Ferret"]
        genderArray = ["Gender:", "Male", "Female", "Male Neutered", "Female Spayed"]
        
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        stepper.wraps = true
        stepper.autorepeat = true
    }
    
    //MARK: Actions
    @IBAction func addPetTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            
            alert(error!)
        }
        else
        {
            
            let petName = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let weight = stepper.value.description
            
            //Saves Pet data within the user's UID node in the database.
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                
                self.ref.child("Users/\(uid)/Pets/petName").setValue(petName)
                self.ref.child("Users/\(uid)/Pets/age").setValue(age)
                self.ref.child("Users/\(uid)/Pets/weight").setValue(weight)
                self.ref.child("Users/\(uid)/Pets/species").setValue(selectedBreed)
                self.ref.child("Users/\(uid)/Pets/gender").setValue(selectedGender)
                
                self.moveToHomeVC()
            } else{
                
                self.alert("Unable to add User's full name to profile.")
            }
        }
    }
    
    //Pulls up the image library on the device and allows a user to select an image
    @IBAction func addImageTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Updates the weight label with the value of the stepper
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        weightLabel.text = Int(sender.value).description + "lb"
    }
    
    //MARK: Helper Methods
    func validateFields() -> String?{
        
        if selectedGender == "" || selectedGender == "Gender:" || selectedBreed == "" || selectedBreed == "Breed" || nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "You must enter a name for your pet, select a species, and a gender!"
        }
        
        return nil
    }
    
    //lets the user know something is wrong when a field is empty or something is not selected.
    func alert(_ message: String){
        let alert = UIAlertController(title: "Oops!", message: "\(message)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Changes root controller so the authenticated user gets access to the full app.
    func moveToHomeVC(){
        let homeViewController = storyboard?.instantiateViewController(identifier: "toHome") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
     //MARK: Protocols
    
    //user picks an image and populates the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
        return 2
    }
    
    //tells picker how many rows in each column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component{
        case 0:
            return breedArray.count
        case 1:
            return genderArray.count
        default:
            print("Error!")
            return 1
        }
    }
    
    //pulls title for selected row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return breedArray[row]
        case 1:
            
            return genderArray[row]
        default:
            print("Error!")
            return breedArray[row]
        }
        
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       switch component{
       case 0:
           selectedBreed = breedArray[row]
        print(selectedBreed)
       case 1:
           selectedGender = genderArray[row]
        print(selectedGender)
       default:
           print("Error!")
       }
    }
}
