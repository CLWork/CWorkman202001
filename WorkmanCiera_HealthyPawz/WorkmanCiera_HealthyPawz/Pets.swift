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
    var name: String
    var species: String
    var age: Int
    
    //Optional information
    var imgURL: String?
    
    
    init(name: String, species: String, age: Int){
        self.name = name
        self.species = species
        self.age = age
    }
}
