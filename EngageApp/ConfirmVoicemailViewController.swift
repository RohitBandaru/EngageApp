//
//  ConfirmVoicemailViewController.swift
//  EngageApp
//
//  Created by Grace Lam on 1/10/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit

class ConfirmVoicemailViewController: UIViewController {
    
    @IBOutlet var sendButton: UIButton!
    
    var audioFile: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        
        //print(audioFile)
    }
    
    @IBAction func changeColorOnTouch(sender:UIButton) {
        sendButton.backgroundColor = UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )
        sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    @IBAction func deletePushed(sender:UIButton) {
        self.performSegue(withIdentifier: "doneSegueUnwind", sender: self)
        
    }
    
}
