//
//  BackupLogin.swift
//  EngageApp
//
//  Created by Grace Lam on 2/1/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation

class BackupLogin {
    
    var username: String!
    var password: String!
    
    func login() {
        var myUrl = URL(string: "http://app.searchnrecruit.com/signin?" + "username=" + self.username + "&password=" + self.password);
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        //let postString = "username=" + self.username + "&password=" + self.password;
        
        //request.httpBody = postString.data(using: String.Encoding.utf8);
        //request.httpBody = postString.data(using: String.Encoding.ascii)
        
        /**
         request.timeoutInterval = 60
         request.httpShouldHandleCookies=false
         
         let queue:OperationQueue = OperationQueue()
         
         NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue) { (response, data, error) in
         
         do {
         if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
         print("ASynchronous\(jsonResult)")
         }
         } catch let error as NSError {
         print(error.localizedDescription)
         }
         }*/
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // print out response object
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response data = \(responseString)")
            
            // convert response sent from a server side script to a NSDictionary object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // access value by key
                    let sessionValue = parseJSON["session"] as? Bool
                    print("session: \(sessionValue)")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func login2() {
        let myUrl = URL(string: "http://app.searchnrecruit.com/signin/");
        let request:NSMutableURLRequest = NSMutableURLRequest(url:myUrl!)
        request.httpMethod = "POST"
        let bodyData = "username=" + self.username + "&password=" + self.password;
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
        }
    }
    
    func login3() {
        var url : String = "http://app.searchnrecruit.com/signin?" + "username=" + self.username + "&password=" + self.password;
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // print response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            
            // convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // print dictionary
                    print(convertedJsonIntoDict)
                    
                    // get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
        /**
         NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue()) { (response, data, error) in
         print("ABC")
         var error1: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
         do {
         let jsonResult: NSDictionary! = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
         print("A")
         if (jsonResult != nil) {
         print(jsonResult)
         print("B")
         } else {
         // couldn't load JSON, look at error
         print(error)
         print("C")
         }
         } catch let error as NSError {
         print(error.localizedDescription)
         }
         }*/
    }
}
