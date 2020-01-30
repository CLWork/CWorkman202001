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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPetInformation()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //reference to realtime database
        dbRef = Database.database().reference()
    }
    
    
    //MARK: Helper Methods
    
    //retrieve pet image
    func getPetImage(){
        
        let uid = getUID()
        if uid != nil{
            let storageRef = Storage.storage().reference(withPath: "images/\(uid!)Sea")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                }
                
                if let data = data {
                    self.petImage = UIImage(data: data)
                }
            }
        }
    }
    
    //pull pet info
    func getPetInformation(){
        
        dbRef?.child("Users").child("Pets").observe(.value, with: { (snapshot) in
            print(snapshot)
        })
        
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
        return 1
    }
    
    //cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath) as? HomeScreenCell else {return tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath) }
        
        cell.petPhoto.image = UIImage(named: "placeholder")
        cell.ageLabel.text = "Age: \(age.description)"
        cell.petNameLabel.text = petName
        
        return cell
    }

}
