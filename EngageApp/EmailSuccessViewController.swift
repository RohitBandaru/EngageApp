//
//  EmailDraftViewController.swift
//  EngageApp
//
//  Created by Grace Lam on 1/23/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import Speech

class EmailSuccessViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isHidden = true
        backButton.isEnabled = false
        
        homeButton.layer.cornerRadius = 5
        homeButton.layer.borderWidth = 1
        homeButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        homeButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        homeButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        homeButton.setTitleColor(UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 ), for: UIControlState.normal)
    }
    
    @IBAction func backPushed(sender:UIButton) {
        self.performSegue(withIdentifier: "successToEmailUnwind", sender: self)
        
    }
    
    @IBAction func changeColorOnTouch(sender:UIButton) {
        homeButton.backgroundColor = UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )
        homeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }

}
