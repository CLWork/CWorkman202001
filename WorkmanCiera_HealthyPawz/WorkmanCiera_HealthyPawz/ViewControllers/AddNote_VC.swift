//
//  AddNote_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/29/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit

class AddNote_VC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var playTimePicker: UIPickerView!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    
    //Variables
    var playTimeHour = [String]()
    var playTimeMinute = [String]()
    var selectedHour: String?
    var selectedMin: String?
    var noteBody = ""
    var weight: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playTimeHour = ["Hour:", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10","11","12","13","14","15","16","17","18","19","20","21","22", "23"]
        playTimeMinute = ["Minute:", "5", "10", "15", "20", "25","30", "35","40", "45", "50", "55" ]
        
        playTimePicker.delegate = self
        playTimePicker.dataSource = self
        
    }
    
    
    //MARK: Actions
    @IBAction func addNoteTapped(_ sender: UIButton) {
        
        let error = validateFields()
        if error != nil{
            alert(error!)
        } else{
            
            
            
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        
    }
    
    //MARK: Helper Methods
    func validateFields() -> String?{
        
        //makes sure the user enters details for notes.
        if noteTV.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your note details in the text box."
        }
        
        //makes sure the user names their note
        if titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "A title is required, please enter a title."
        }
        
        //ensures picker values are nil if the user hasn't selected something from it or changed it to Hour/Minute
        if selectedHour == nil || selectedHour == "Hour:"{
            selectedHour = nil
        }
        if selectedMin == nil || selectedMin == "Minute:"{
            selectedMin = nil
        }
        
        //If weight isn't added, specify Nil
        if weightTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            weight = nil
        }
        return nil
    }
    
    //lets the user know something is wrong.
    func alert(_ message: String){
        let alert = UIAlertController(title: "Oops!", message: "\(message)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }

    //MARK: Protocols
    
    //tells picker how many columns
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //tells picker how many rows per component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component{
        case 0:
            return playTimeHour.count
        case 1:
            return playTimeMinute.count
        default:
            return 1
        }
    }
    
    //pulls title for selected row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return playTimeHour[row]
        case 1:
            
            return playTimeMinute[row]
        default:
            print("Error!")
            return playTimeHour[row]
        }
        
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       switch component{
       case 0:
           selectedHour = playTimeHour[row]
       
       case 1:
           selectedMin = playTimeMinute[row]
        
       default:
           print("Error!")
       }
    }
    
    //allows return key to switch textfields for the user
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag{
        case 0:
            titleTF.resignFirstResponder()
            weightTF.becomeFirstResponder()
        case 1:
            weightTF.resignFirstResponder()
            noteTV.becomeFirstResponder()
        case 2:
            noteTV.resignFirstResponder()
        default:
            titleTF.becomeFirstResponder()
        }
        
        return true
    }

}
