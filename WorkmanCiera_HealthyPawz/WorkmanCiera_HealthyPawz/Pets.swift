//
//  Pets.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/22/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import Foundation

class Pets{
    
    //Member variables
    //Required information
    var uid: String
    var name: String
    var species: String
    var age: Int
    var weight: Int
    
    //Optional Information
    var imgURL: String?
    
    //initializer
    init(uid: String, name: String, species: String, age: Int, weight: Int){
        self.uid = uid
        self.name = name
        self.species = species
        self.age = age
        self.weight = weight
    }
}
