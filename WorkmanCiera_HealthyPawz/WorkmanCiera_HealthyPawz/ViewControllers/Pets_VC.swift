//
//  Pets_VC.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/21/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

private let g_cellID1 = "cell_ID_1"
class Pets_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
   
    
    
    //Variables
    var petImage: UIImage?
    var petName = "Test"
    var age = 0
    var dbRef: DatabaseReference?
    var petArray = [Pets]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //reference to realtime database
        dbRef = Database.database().reference()
        
        
         getPetInformation()
         getPetImage()
    }
    
    
    //MARK: Helper Methods
    
    //retrieve pet image
    func getPetImage(){
        
        let uid = getUID()
        if uid != nil{
            for pet in petArray{
                let storageRef = Storage.storage().reference(withPath: "images/\(uid!)\(pet.name)")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                }
                
                if let data = data {
                    self.petImage = UIImage(data: data)
                    print("Successfully found image!")
                    self.tableView.reloadData()
                }
            }
        }
        }
    }
    
    //pull pet info
    func getPetInformation(){
        
        let uid = getUID()
        if uid != nil{
            dbRef?.child("Pets").observe(.value, with: { (snapshot) in
                if let listOfPets = snapshot.value as? [String: Any]{
                    for (_, petObj) in listOfPets{
                        if let petObj = petObj as? [String: Any]{
                            let userID = petObj["uid"] as? String
                            
                            if userID == uid{
                                print("\n\nFound matching pet")
                                guard let petName = petObj["petName"] as? String,
                                    let petAge = petObj["age"] as? String,
                                    let petWeight = petObj["weight"] as? String,
                                    let petSpecies = petObj["species"] as? String,
                                    let petGender = petObj["gender"] as? String
                                    else {continue}
                                
                                let newPet = Pets(pName: petName, pAge: petAge, pWeight: petWeight, pUid: userID!, pSpecies: petSpecies, pGender: petGender)
                                self.petArray.append(newPet)
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

    //retrieves current user's ID
    func getUID() -> String?{
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            return uid
        }
        return nil
    }
    
    // MARK: Protocols
    
    //how many sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petArray.count
    }
    
    //cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath) as? HomeScreenCell else {return tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath) }
        
        cell.petPhoto.image = UIImage(named: "placeholder")
        cell.ageLabel.text = "Age: \(petArray[indexPath.row].age)"
        cell.petNameLabel.text = petArray[indexPath.row].name
        
        return cell
    }

}
