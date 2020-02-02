//
//  Pets.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 2/1/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import Foundation
import UIKit

class Pets{
    
    var name: String
    var age: String
    var weight: String
    var uid: String
    var species: String
    var gender: String
    var imageName: String
    var image: UIImage?
    
    
    
    init(pName: String, pAge: String, pWeight: String, pUid: String, pSpecies: String, pGender: String, pImageName: String){
        
        self.name = pName
        self.age = pAge
        self.weight = pWeight
        self.uid = pUid
        self.species = pSpecies
        self.gender = pGender
        self.imageName = pImageName
    }
}
