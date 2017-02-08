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
import MessageUI

class EmailDraftViewController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    var audioFile: NSURL!
    var candidate: Candidate!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var checkButton: UIButton!
    
    let checkedImage = UIImage(named: "checked box")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked box")! as UIImage
    
    var transcription:String = ""
    var emailAddress:String = ""
    var subject:String = "Message from Engage App"
    var recordingName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        nameLabel.text = candidate.fullName
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont.init(name: "Avenir Next", size: 15)
        
        checkButton.setBackgroundImage(uncheckedImage, for: UIControlState.normal)
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        
        transcriptAudioFile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        sendButton.setTitleColor(UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 ), for: UIControlState.normal)
    }
    
    // set up mail screen
    func composeEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddress])
            mail.setMessageBody(transcription, isHTML: false)
            mail.setSubject(subject)

            
            if checkButton.currentBackgroundImage == checkedImage {
                if let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as? String {
                    var fileManager = FileManager.default
                    var filecontent = fileManager.contents(atPath: docsDir + "/" + recordingName)
                    mail.addAttachmentData(filecontent!, mimeType: "audio/x-wav", fileName: recordingName)
                }
            }
            
            present(mail, animated: true)
        } else {
            // failure alert
        }
    }
    
    // dismiss mail screen
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            self.performSegue(withIdentifier: "emailSuccessSegue", sender: self)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func animateTextField(textView: UITextView, up: Bool) {
        let moveDist:Int = -100 //224
        let moveDuration:Float = up ? 0.3 : 0.2
        let movement:Int = up ? moveDist : -moveDist
        
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(moveDuration))
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.textView {
            self.animateTextField(textView: textView, up: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.textView {
            self.animateTextField(textView: textView, up: false)
        }
    }
    
    // transcripting audio recording to message
    func transcriptAudioFile() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if let path = self.audioFile {
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path as URL)
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            self.textView.text = (result?.bestTranscription.formattedString)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func backPushed(sender:UIButton) {
        self.performSegue(withIdentifier: "emailToOptionsUnwind", sender: self)
        
    }
    
    @IBAction func sendPushed(sender:UIButton) {
        self.transcription = self.textView.text
        composeEmail()
        
    }
    
    @IBAction func changeColorOnTouch(sender:UIButton) {
        sendButton.backgroundColor = UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )
        sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    @IBAction func checkButtonPushed(sender:UIButton) {
        if (checkButton.currentBackgroundImage == uncheckedImage) {
            checkButton.setBackgroundImage(checkedImage, for: UIControlState.normal)
        } else {
            checkButton.setBackgroundImage(uncheckedImage, for: UIControlState.normal)
        }
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        sendButton.layer.borderColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 )).cgColor
        sendButton.backgroundColor = (UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 0.1 ))
        sendButton.setTitleColor(UIColor( red: 29/255.0, green: 161/255.0, blue: 207/255.0, alpha: 1 ), for: UIControlState.normal)
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "successToEmailUnwind" {
                let unwindSegue = SegueFromLeftUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }

}
