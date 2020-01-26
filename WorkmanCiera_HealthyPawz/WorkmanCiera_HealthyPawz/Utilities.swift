//
//  Utilities.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/22/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import Foundation

class Utilities{
    
      //ensures password is valid and secure enough by requiring a length of 8, special character, and a number
    func isPasswordValid(_ password: String) -> Bool{
           let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
           return passwordTest.evaluate(with: password)
       }
    
    // Email validation here
    func isEmailVallid(_ email: String) -> Bool{
        if email.contains("@") && (email.contains(".com") || email.contains(".net") || email.contains(".org") || email.contains(".edu")){
             return true
        } else
        {
            return false
        }
       
    }
       
}


