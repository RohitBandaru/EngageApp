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
    var fullName: String
    var location: String
    var position: String
    var company: String
    var id: String
    var currentEmails:[String]
    
    
    init(fullName: String, location: String, position: String, company: String, id: String, currentEmails:[String]){
        self.fullName = fullName
        self.location = location
        self.position = position
        self.company = company
        self.id = id
        self.currentEmails = currentEmails
    }
}
