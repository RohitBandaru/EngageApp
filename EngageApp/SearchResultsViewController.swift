//
//  SearchResultsViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var searchResults:[Candidate] = [Candidate]()
    var selectedCandidate:Candidate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // display non null information
        if(candidate.position != "" && candidate.company != ""){
            cell.position.text = candidate.position + " at " + candidate.company
        }
        else if(candidate.company != ""){
            cell.position.text = candidate.company
        }
        else if(candidate.position != ""){
            cell.position.text = candidate.position
        }
        else{
            cell.position.text = ""
        }
        
        cell.location.text = (candidate.location != "null") ? candidate.location : ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCandidate = searchResults[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "segueToRecorder", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass the candidate's info to the next view controller
        if segue.identifier == "segueToRecorder" {
            let destinationViewController = segue.destination as! VoicemailViewController
            destinationViewController.candidate = selectedCandidate
        }
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        // N/A
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "voicemailToSearchResults" {
                let unwindSegue = SegueFromLeftUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }
}
