//
//  SearchAPI.swift
//  EngageApp
//
//  Created by Rohit Bandaru on 1/13/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

extension String {
    var isAlpha: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

class SearchAPI {
    let queryName: String
    let queryLocation: String
    let queryCompany:String
    var candidates:[Candidate] = [Candidate]()
    
    init(queryName: String, queryLocation: String, queryCompany: String){
        self.queryName = queryName
        self.queryLocation = queryLocation
        self.queryCompany = queryCompany
    }
    
    func getURLString() -> String {
        let baseURL = "http://104.154.45.194:80/search_n_recruit/contact/_search?from=0&size=50&q="
        // add name to query
        var url = baseURL + ("+fullName:\""+queryName+"\"").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        // add location to query
        url += ("+location:\"" + queryLocation + "\"").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        // add company to query if valid
        url += ("+experience.organization.companyName:\"" + queryCompany + "\"").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        return url
    }
    
    func getJSON(success: (([Candidate])->Void)?){
        Alamofire.request(getURLString(), headers: ["X-API-KEY": "ZWxhc3RpY3NlYXJjaC10ZXN0bW9iaWxlYXBwZGV2"]).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                var candidates:[Candidate] = [Candidate]()
                let jsonHits = json["hits"]["hits"]
                
                for i in 0...jsonHits.count{
                    let id = jsonHits[i]["_id"].rawString()
                    let source = jsonHits[i]["_source"]
                    let fullName = source["fullName"].rawString()
                    let location = source["location"].rawString()
                    let company = source["currentCompanyName"].rawString()
                    let position = source["currentCompanyTitle"].rawString()
                    
                    let currentEmailsSource = source["currentEmails"]
                    var currentEmails:[String] = []
                    for index in 0...currentEmailsSource.count {
                        var email = currentEmailsSource[index].rawString()!
                        if(!(email == "null") && email.isValidEmail){
                            currentEmails.append(email)
                        }
                    }
                    
                    // candidate is only shown if the query name is contained in the candidate name in any order
                    let nameArray: [String] = (fullName?.lowercased().components(separatedBy: " "))!
                    let queryNameArray: [String] = self.queryName.lowercased().components(separatedBy: " ")
                    
                    var parsedName = ""
                    for name in nameArray {
                        if(name.isAlpha){
                            parsedName += name + " "
                        }
                    }
                    
                    var dontAppend = false
                    if(self.queryName != ""){
                        for name in queryNameArray{
                            if !nameArray.contains(name){
                                dontAppend = true
                            }
                        }
                    }
                    
                    let notNullLocation = (location != "null") ? location : ""
                    let notNullPosition = (position != "null") ? position : ""
                    let notNullCompany = (company != "null") ? company : ""
                    let candidate = Candidate(fullName: parsedName.capitalized, location: notNullLocation!, position: notNullPosition!, company: notNullCompany!, id: id!, currentEmails: currentEmails)
                    if(!dontAppend){
                        candidates.append(candidate)
                    }
                }
                success!(candidates)
            }
        }
    }
}
