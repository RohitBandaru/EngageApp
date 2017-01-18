//
//  SearchingViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchingViewController: UIViewController {

    var queryName = String()
    var queryLocation = String()
    var queryCompany = String()
    var candidates = [Candidate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(queryCompany)
        // Do any additional setup after loading the view, typically from a nib.
        let api = SearchAPI(queryName: queryName, queryLocation: queryLocation, queryCompany: nil)
        api.getJSON(success: { candidates in
            api.candidates = candidates
            self.candidates = candidates
            //set up results screen
            //segue to results page, pass candidates array
            self.performSegue(withIdentifier: "results", sender: self)
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "results"){
            var destinationViewController:SearchResultsViewController = segue.destination as! SearchResultsViewController
            destinationViewController.searchResults = self.candidates
        }
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
