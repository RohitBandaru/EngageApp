//
//  SearchResultsViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // to do, segue to record screen, and pass candidate object
    
    var searchResults:[Candidate] = [Candidate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! resultCellTableViewCell
        let candidate = searchResults[indexPath.row]
        cell.name.text = candidate.fullName
        cell.position.text = candidate.position + " at " + candidate.company
        // cell.company.text = candidate.company!
        cell.location.text = candidate.location
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
