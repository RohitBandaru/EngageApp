//
//  SearchingViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchingViewController: UIViewController {
    var candidate1 = Candidate(firstName: "John", lastName: "Smith", location: "Kansas", phoneNumber: "9789872222", position: "manager", company: "BOA")
    var candidate2 = Candidate(firstName: "Irene", lastName: "Thof", location: "enwk", phoneNumber: "3289872222", position: "cashier", company: "BOA")
    var candidate3 = Candidate(firstName: "Jinj", lastName: "Fith", location: "enwk", phoneNumber: "4359872222", position: "accountant", company: "BOA")
    var candidate4 = Candidate(firstName: "Erin", lastName: "Thin", location: "enwk", phoneNumber: "8899872222", position: "assistant manager", company: "raytheon")
    
    var searchResults:[Candidate]?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults = [self.candidate1, self.candidate2, self.candidate3, self.candidate4]
        // Do any additional setup after loading the view.
        
        // Do API call here
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
