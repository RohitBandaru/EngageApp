//
//  Candidate.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/11/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit

class Candidate {
    var firstName: String
    var lastName: String
    var location: String
    var phoneNumber: String?
    var position: String?
    var company: String?
    
    init(firstName: String, lastName: String, location: String, phoneNumber: String?, position: String, company: String){
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.phoneNumber = phoneNumber
        self.position = position
        self.company = company
    }
    
    
}
