//
//  LogInViewController.swift
//  EngageApp
//
//  Created by Grace Lam on 1/30/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var username: String!
    var password: String!
    var loginStatus: Int! // 0: success, 1: invalid username, 2: invalid password, 3: default
    var pwdReset: Int! // 0: success, 1: invalid username, 2: default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        loginStatus = 3
        pwdReset = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isInternetAvailable() {
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    @IBAction func signInPushed(sender: UIButton) {
        self.username = usernameTextField.text
        self.password = passwordTextField.text
        login()
    }
    
    @IBAction func forgotPasswordPushed(sender: UIButton) {
        let alert = UIAlertController(title: "Reset Password", message: "Please enter your username below.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
            let userTextField = alert.textFields![0] as UITextField
            self.forgotPwdServletCall(user: userTextField.text!)
        }
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter username"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func forgotPwdServletCall(user: String) {
        let myUrl = URL(string: "http://app.searchnrecruit.com/forgotpwd?" + "email=" + user);
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // print out response object
            //print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response data = \(responseString)")
            
            // convert response sent from a server side script to a NSDictionary object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // access value by key
                    if parseJSON["success"] != nil {
                        self.pwdReset = 0
                    } else {
                        self.pwdReset = 1
                    }
                    
                    DispatchQueue.main.async (execute: { () -> Void in
                        self.finishPassReset()
                    })
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func finishPassReset() {
        if self.pwdReset == 0 {
            let alert = UIAlertController(title: "Password Reset Link Sent", message: "A password reset link has been sent to your email.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
            
        } else {
            let alert = UIAlertController(title: "Invalid Username", message: "The username you entered could not be found.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    @IBAction func newAccountPushed(sender: UIButton) {
        let alert = UIAlertController(title: "Create an Account", message: "Please create an account on app.searchnrecruit.com.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        }
        let safariAction = UIAlertAction(title: "Open Link", style: .default) { (action:UIAlertAction!) in
            
            if let url = URL(string: "http://app.searchnrecruit.com") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(safariAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func finishLogin() {
        if self.loginStatus == 0 {
            self.performSegue(withIdentifier: "signInSegue", sender: self)
            
        } else if self.loginStatus == 1 {
            let alert = UIAlertController(title: "Error", message: "Invalid username. Please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
            
        } else if self.loginStatus == 2 {
            let alert = UIAlertController(title: "Error", message: "Invalid password. Please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
            
        }
    }
    
    func login() {
        let myUrl = URL(string: "http://app.searchnrecruit.com/signin?" + "username=" + self.username + "&password=" + self.password);
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // print out response object
            //print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response data = \(responseString)")
            
            // convert response sent from a server side script to a NSDictionary object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // access value by key
                    //let sessionValue = parseJSON["session"] as? Bool
                    //print("session: \(sessionValue)")
                    print(parseJSON)
                    if parseJSON["forwardpage"] != nil {
                        self.loginStatus = 0
                    } else if parseJSON["wrongPassward"] != nil {
                        self.loginStatus = 2
                    } else {
                        self.loginStatus = 1
                    }
                    
                    DispatchQueue.main.async (execute: { () -> Void in
                        self.finishLogin()
                    })
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func animateTextField(textField: UITextField, up: Bool) {
        let moveDist:Int = (textField == usernameTextField) ? -50 : -45
        let moveDuration:Float = up ? 0.3 : 0.2
        let movement:Int = up ? moveDist : -moveDist
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(moveDuration))
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
