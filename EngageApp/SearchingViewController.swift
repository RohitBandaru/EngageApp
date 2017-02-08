//
//  SearchingViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchingViewController: UIViewController {
    
    var queryName = String()
    var queryLocation = String()
    var queryCompany = String()
    var candidates = [Candidate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let api = SearchAPI(queryName: queryName, queryLocation: queryLocation, queryCompany: queryCompany)
        api.getJSON(success: { candidates in
            api.candidates = candidates
            self.candidates = candidates
            //segue to results page, pass candidates array
            self.performSegue(withIdentifier: "results", sender: self)
        })
        
        let animationView: NVActivityIndicatorView = NVActivityIndicatorView(frame: self.view.frame)
        self.view.addSubview(animationView)
        
        animationView.type = .ballSpinFadeLoader
        animationView.padding = 100
        animationView.color = UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )
        animationView.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "results"){
            let destinationViewController:SearchResultsViewController = segue.destination as! SearchResultsViewController
            destinationViewController.searchResults = self.candidates
        }
    }
}
