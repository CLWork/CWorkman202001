//
//  PetNotes.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 2/2/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import Foundation

class PetNotes{
    
    //member variables - required
    let petName: String
    let title: String
    let noteDetails: String
    
    //optional member variables
    var weight: String?
    var pTHour: String?
    var pTMin: String?
    
    //initializer
    init(_petName: String, _title: String, _noteDetails: String){
        self.petName = _petName
        self.title = _title
        self.noteDetails = _noteDetails
    }
    
}
