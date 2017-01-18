//
//  SearchViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        // perform segue to searching screen, pass text fields
        self.performSegue(withIdentifier: "search", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "search"){
            var destinationViewController:SearchingViewController = segue.destination as! SearchingViewController
            destinationViewController.queryName = nameField.text!
            destinationViewController.queryLocation = locationField.text!
            destinationViewController.queryCompany = companyField.text!
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
