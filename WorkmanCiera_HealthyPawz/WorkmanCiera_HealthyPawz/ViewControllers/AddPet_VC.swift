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

class AddPet_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {

    //Outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var weightTF: UITextField!
    
    //Variables
    let imagePicker = UIImagePickerController()
    var breedArray = [String]()
    var selectedBreed = ""
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
        breedArray = ["Breed:","Cat", "Dog", "Bird", "Rabbit", "Rodent", "Ferret"]
        genderArray = ["Gender:", "Male", "Female", "Male Neutered", "Female Spayed"]
        
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    //MARK: Actions
    @IBAction func addPetTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil{
            
            alert(error!)
        }
        else
        {
            //captures entered information after validation.
            let petName = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let weight = weightTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            //Saves Pet data within it's own tree with uid saved for retrieval.
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                
                let childName = "\(uid)_\(petName!)"
                
                
                if self.petImage != nil{
                    self.uploadImage(uid, petName: petName!)
                }
                
                
                self.ref.child("Pets/\(childName)/uid").setValue(uid)
                self.ref.child("Pets/\(childName)/petName").setValue(petName)
                self.ref.child("Pets/\(childName)/age").setValue(age)
                self.ref.child("Pets/\(childName)/weight").setValue(weight)
                self.ref.child("Pets/\(childName)/species").setValue(selectedBreed)
                self.ref.child("Pets/\(childName)/gender").setValue(selectedGender)
                self.ref.child("Pets/\(childName)/petImageName").setValue(petImageName)
                
                self.moveToHomeVC()
                
            } else{
                
                self.alert("Unable to add pet information.")
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
        
        if selectedGender == "" || selectedGender == "Gender:" || selectedBreed == "" || selectedBreed == "Breed" || nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weightTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || weightTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "0" || weightInt == 0{
            
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
                print(self.petImageName!)
                
            }
        }
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
            return breedArray.count
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
            return breedArray[row]
        case 1:
            
            return genderArray[row]
        default:
            print("Error loading Picker values.")
            return breedArray[row]
        }
        
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       switch component{
       case 0:
           selectedBreed = breedArray[row]
       case 1:
           selectedGender = genderArray[row]
       default:
           alert("Error using Picker, please try your selection again.")
       }
    }
}
