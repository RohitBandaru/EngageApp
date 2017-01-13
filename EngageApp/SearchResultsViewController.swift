//
//  SearchResultsViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var candidate1 = Candidate(firstName: "John", lastName: "Smith", location: "Kansas", phoneNumber: "9789872222", position: "manager", company: "BOA")
    var candidate2 = Candidate(firstName: "Irene", lastName: "Thof", location: "enwk", phoneNumber: "3289872222", position: "cashier", company: "BOA")
    var candidate3 = Candidate(firstName: "Jinj", lastName: "Fith", location: "enwk", phoneNumber: "4359872222", position: "accountant", company: "BOA")
    var candidate4 = Candidate(firstName: "Erin", lastName: "Thin", location: "enwk", phoneNumber: "8899872222", position: "assistant manager", company: "raytheon")
    
    var searchResults:[Candidate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResults = [self.candidate1, self.candidate2, self.candidate3, self.candidate4]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! resultCellTableViewCell
        let candidate = searchResults![indexPath.row]
        cell.name.text = candidate.firstName + " " + candidate.lastName
        cell.position.text = candidate.position! + " at " + candidate.company!
        // cell.company.text = candidate.company!
        cell.location.text = candidate.location
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
