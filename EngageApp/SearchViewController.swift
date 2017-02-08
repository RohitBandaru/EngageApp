//
//  SearchViewController.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        if ((nameField.text! == "") && (locationField.text! == "") && (companyField.text! == "")) {
            let alert = UIAlertController(title: "Invalid Search", message: "Please enter a name, location, or company to search.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion:nil)
        } else {
            // perform segue to searching screen, pass text fields
            self.performSegue(withIdentifier: "search", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        locationField.delegate = self
        companyField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    func animateTextField(textField: UITextField, up: Bool) {
        let moveDist:Int = -195 //224
        let moveDuration:Float = up ? 0.3 : 0.2
        let movement:Int = up ? moveDist : -moveDist
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(moveDuration))
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == companyField {
            self.animateTextField(textField: textField, up: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == companyField {
            self.animateTextField(textField: textField, up: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
