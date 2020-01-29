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

private let g_cellID1 = "cell_ID_1"
class Pets_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //Variables
    var petImage: UIImage?
    var petName = "Test"
    var age = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPetInformation()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: Helper Methods
    func getPetInformation(){
        
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

    func getUID() -> String?{
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            return uid
        }
        return nil
    }
    
    // MARK: Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath) as? HomeScreenCell else {return tableView.dequeueReusableCell(withIdentifier: g_cellID1, for: indexPath) }
        
        cell.petPhoto.image = petImage
        cell.ageLabel.text = "Age: \(age.description)"
        cell.petNameLabel.text = petName
        
        return cell
    }

}
