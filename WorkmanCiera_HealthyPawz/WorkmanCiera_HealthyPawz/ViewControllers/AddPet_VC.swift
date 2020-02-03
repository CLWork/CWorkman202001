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
import FirebaseStorage

class AddPet_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var speciesPicker: UIPickerView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var addPetBttn: UIButton!
    
    //Variables
    let imagePicker = UIImagePickerController()
    var speciesArray = [String]()
    var selectedSpecies = ""
    var genderArray = [String]()
    var selectedGender = ""
    var ref: DatabaseReference!
    var storage = Storage.storage()
    var storageRef = Storage.storage().reference()
    var petImage: UIImage?
    var petImageName: String?
    let petName = ""
    let age = ""
    let weight = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference database
        ref = Database.database().reference()
        
        //Populate arrays for the picker
        speciesArray = ["Breed:","Cat", "Dog", "Bird", "Rabbit", "Rodent", "Ferret"]
        genderArray = ["Gender:", "Male", "Female", "Male Neutered", "Female Spayed"]
        
        //
        speciesPicker.delegate = self
        speciesPicker.dataSource = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    //MARK: Actions
    
    //adds pet info to DB and transitions when complete.
    @IBAction func addPetTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil{
            
            alert(error!)
        }
        
        else{
            
            let petName = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                
                if petImage != nil{
                    uploadImage(uid, petName: petName!)
                }
                else{
                    savePetInfoToDB(petName: petName!, uid: uid)
                }
                
            }
            
        }
       
    }
    
    //Pulls up the image library on the device and allows a user to select an image
    @IBAction func addImageTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Helper Methods
    
    //checks for empty textfields and a weight value equaling 0 
    func validateFields() -> String?{
        
        let weightInt = Int(weightTF.text ?? "0")
        
        if selectedGender == "" || selectedGender == "Gender:" || selectedSpecies == "" || selectedSpecies == "Breed" || nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weightTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || weightTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "0" || weightInt == 0{
            
            return "You must enter a name for your pet, select a species, enter a weight above 0 and a gender!"
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
    
    //Uploads the selected image to the Cloud Storage, uses the loggedIn user's ID and pet name as a file name.
    func uploadImage(_ userID: String, petName: String){
        let uploadReference = Storage.storage().reference(withPath: "images/\(userID)" + "\(petName)")
        guard let imageData = petImageView.image?.jpegData(compressionQuality: 0.75) else {return}
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
          uploadReference.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            
            if let error = error{
                
                self.alert(error.localizedDescription)
                
            } else{
                
                self.petImageName = downloadMetadata?.name
               
                self.savePetInfoToDB(petName: petName, uid: userID)
            }
            
        }
        
    }
    
    //saves to database
    func savePetInfoToDB(petName: String, uid: String){

        //captures entered information after validation.
        let age = ageTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let weight = weightTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        //specfified node name format.
        let childName = "\(uid)_\(petName)"
        
        //enters user's pet information into the database
        ref.child("Pets/\(childName)/uid").setValue(uid)
        ref.child("Pets/\(childName)/petName").setValue(petName)
        ref.child("Pets/\(childName)/age").setValue(age)
        ref.child("Pets/\(childName)/weight").setValue(weight)
        ref.child("Pets/\(childName)/species").setValue(selectedSpecies)
        ref.child("Pets/\(childName)/gender").setValue(selectedGender)
        ref.child("Pets/\(childName)/petImageName").setValue(petImageName)
        
        moveToHomeVC()
    }
    
    //MARK: Protocols
    
    //user picks an image and populates the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            petImageView.image = pickedImage
            petImage = pickedImage
            
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
            return speciesArray.count
        case 1:
            return genderArray.count
        default:
            print("Error loading Picker counts!")
            return 1
        }
    }
    
    //pulls title for selected row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return speciesArray[row]
        case 1:
            
            return genderArray[row]
        default:
            print("Error loading Picker values.")
            return speciesArray[row]
        }
        
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       switch component{
       case 0:
           selectedSpecies = speciesArray[row]
       case 1:
           selectedGender = genderArray[row]
       default:
           alert("Error using Picker, please try your selection again.")
       }
    }
    //allows return key to switch textfields for the user
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag{
        case 0:
            nameTF.resignFirstResponder()
            ageTF.becomeFirstResponder()
            
        case 1:
            ageTF.resignFirstResponder()
            weightTF.becomeFirstResponder()
            
        case 2:
            weightTF.resignFirstResponder()
        
        default:
            nameTF.becomeFirstResponder()
            
        }
        
        return true
    }
}
