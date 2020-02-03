//
//  Notes.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 2/2/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import Foundation

class Notes{
    
    var title: String
    var pet: String
    var body: String
    
    //optional
    var weight: String?
    var ptHour: String?
    var ptMin: String?
    
    init(_title: String, _pet: String, _body: String){
        
        self.title = _title
        self.pet = _pet
        self.body = _body
    }
    
}
