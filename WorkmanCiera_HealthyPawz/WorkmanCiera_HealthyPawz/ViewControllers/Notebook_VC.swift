//
//  Notebook_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 2/2/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit
import UIKit
import FirebaseAuth
import FirebaseDatabase

private let g_cellID1 = "cell_ID_1"
class Notebook_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //variables
    var dbRef: DatabaseReference?
    var arrayOfPetNames = [String]()
    var uid: String?
    var notesArray = [PetNotes]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //reference to realtime database
        dbRef = Database.database().reference()
        uid = getUID()
    }
    
    
    //MARK: Helper Methods
    //pull pet info
    func getPetInformation(){
        
        if uid != nil{
            dbRef?.child("Pets").observe(.value, with: { (snapshot) in
                if let listOfPets = snapshot.value as? [String: Any]{
                    for (_, petObj) in listOfPets{
                        if let petObj = petObj as? [String: Any]{
                            let userID = petObj["uid"] as? String
                            
                            if userID == self.uid{
                                print("\n\nFound matching pet")
                                guard let petName = petObj["petName"] as? String
                                    else {continue}
                                
                                self.arrayOfPetNames.append(petName)
                                self.tableView.reloadData()
                            }
                                
                            else {
                                
                                print("No matching pet found")
                            }
                        }
                    }
                    
                }
            })
        }
        
    }
    
    //gets note data
    func getNoteData(){
        
        var weight: String?
        var ptHour: String?
        var ptMin: String?
        
        if uid != nil{
            dbRef?.child("Notes").observe(.value, with: { (snapshot) in
                if let listOfNotes = snapshot.value as? [String: Any]{
                    for (_, noteObj) in listOfNotes{
                        if let noteObj = noteObj as? [String: Any]{
                            let userID = noteObj["uid"] as? String
                            
                            if userID == self.uid{
                                
                                guard let petName = noteObj["petName"] as? String, let title = noteObj["title"] as? String, let noteBody = noteObj["body"] as? String
                                    else {continue}
                                
                                //could be nil or empty, so outside guard statement
                                if noteObj["weight"] != nil{
                                    weight = (noteObj["weight"] as? String)!
                                }
                                
                                if noteObj["hourly"] != nil{
                                    ptHour = noteObj["hourly"] as? String
                                }
                                
                                if noteObj["minute"] != nil{
                                     ptMin = noteObj["minute"] as? String
                                }
                                
                                let newNote = PetNotes(_petName: petName, _title: title, _noteDetails: noteBody)
                                newNote.weight = weight
                                newNote.pTHour = ptHour
                                newNote.pTMin = ptMin
                            
                                self.notesArray.append(newNote)
                                self.tableView.reloadData()
                            }
                                
                            else {
                                
                                print("No notes found!")
                            }
                        }
                    }
                    
                }
            })
        }
        
    }
    
    //retrieves current user's ID
    func getUID() -> String?{
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            return uid
        }
        return nil
    }
    
    //MARK: Protocols
    
    //Separate tableview by number of pets
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfPetNames.count
    }
    
    //adds number of notes per pet
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
        
    }
    
    //configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath)
        return cell
    }
    
    

}
