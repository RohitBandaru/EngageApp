//
//  ConfirmVoicemailViewController.swift
//  EngageApp
//
//  Created by Grace Lam on 1/10/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ConfirmVoicemailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var candidate: Candidate!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var addContactButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var segmentedChoice: UISegmentedControl!
    var emailPicker: UIPickerView!
    var toolBar: UIToolbar!
    
    var emailSliderValues: [String]!
    var audioFile: NSURL!
    var emailAddress:String = ""
    var recordingName:String!
    
    let checkedImage = UIImage(named: "checked circle")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked circle")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = candidate.fullName
        locationLabel.text = candidate.location
        positionLabel.text = candidate.position
        companyLabel.text = candidate.company
        
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        
        addContactButton.isEnabled = true
        addContactButton.alpha = 1
        
        emailPicker = UIPickerView()
        emailPicker.delegate = self
        emailPicker.dataSource = self
        emailPicker.showsSelectionIndicator = true
        
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: "donePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        emailTextField.delegate = self
        emailTextField.inputView = emailPicker
        emailTextField.inputAccessoryView = toolBar
        
        candidate.currentEmails = ["a","b","c"] // for testing purposes
        if candidate.currentEmails.count < 1 {
            emailSliderValues = ["N/A"]
            emailTextField.isEnabled = false
            emailTextField.alpha = 0.3
        } else {
            //emailSliderValues = candidate.currentEmails
            emailSliderValues = ["graceslam@gmail.com", "gracelam@mit.edu", "test@test.com"]
        }
        emailTextField.text = emailSliderValues[0]
        emailAddress = emailSliderValues[0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        sendButton.setTitleColor(UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 ), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return emailSliderValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return emailSliderValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        emailTextField.text = emailSliderValues[row]
        emailAddress = emailSliderValues[row]
    }
    
    func donePicker() {
        emailTextField.resignFirstResponder()
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        let moveDist:Int = -135
        let moveDuration:Float = up ? 0.3 : 0.3
        let movement:Int = up ? moveDist : -moveDist
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(moveDuration))
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.animateTextField(textField: textField, up: true)
            segmentedChoice.selectedSegmentIndex = 1
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            self.animateTextField(textField: textField, up: false)
        }
        return true
    }
    
    @IBAction func segmentedBarChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 && candidate.currentEmails.count == 0 {
            sender.selectedSegmentIndex = 0
            let alert = UIAlertController(title: "Email Address Unavailable", message: "EngageApp does not have any email addresses on file for this candidate. Please send a voicemail.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    @IBAction func addContact(sender: UIButton) {
        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        let fullNameArr: [String] = candidate.fullName.components(separatedBy: " ")
        let nameLen: Int = fullNameArr[fullNameArr.count-1] == "" ? fullNameArr.count-1 : fullNameArr.count
        
        var firstName: String = ""
        if nameLen == 1 {
            contact.givenName = fullNameArr[0]
        } else {
            for i in 0...(nameLen-2) {
                if i == (nameLen-2) {
                    firstName += fullNameArr[i]
                } else {
                    firstName += fullNameArr[i] + " "
                }
            }
            contact.givenName = firstName
            contact.familyName = fullNameArr[nameLen-1]
        }
        
        contact.jobTitle = candidate.position
        contact.organizationName = candidate.company
        contact.note = "from Huna Makia EngageApp"
        
        contact.emailAddresses = []
        for email in candidate.currentEmails {
            var workEmail = CNLabeledValue(label: CNLabelWork, value: email as NSString)
            contact.emailAddresses.append(workEmail)
        }
        
        /**
        let homeEmail = CNLabeledValue(label:CNLabelHome, value:"john@example.com")
        let workEmail = CNLabeledValue(label:CNLabelWork, value:"j.appleseed@icloud.com")
        contact.emailAddresses = [homeEmail, workEmail]
        
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:"(408) 555-0126"))]
        */
        
        // Saving the newly created contact
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
        
        let alert = UIAlertController(title: "Success!", message: "Contact successfully saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:nil)
        
        addContactButton.isEnabled = false
        addContactButton.alpha = 0.25
    }
    
    @IBAction func changeColorOnTouch(sender:UIButton) {
        sendButton.backgroundColor = UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )
        sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    @IBAction func deletePushed(sender:UIButton) {
        self.performSegue(withIdentifier: "doneSegueUnwind", sender: self)
    }
    
    @IBAction func sendPushed(sender:UIButton) {
        if (segmentedChoice.selectedSegmentIndex == 1) {
            self.performSegue(withIdentifier: "draftEmailSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass the recorded file to the next view controller
        if segue.identifier == "draftEmailSegue" {
            let destinationViewController = segue.destination as! EmailDraftViewController
            destinationViewController.audioFile = self.audioFile
            destinationViewController.candidate = self.candidate
            destinationViewController.emailAddress = self.emailAddress
            destinationViewController.recordingName = self.recordingName
        }
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        sendButton.setTitleColor(UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 ), for: UIControlState.normal)
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "emailToOptionsUnwind" {
                let unwindSegue = SegueFromLeftUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }
    
}
