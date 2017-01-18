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

class SearchAPI {
    let queryName: String
    let queryLocation: String
    let queryCompany:String?
    var candidates:[Candidate] = [Candidate]()
    
    init(queryName: String, queryLocation: String, queryCompany: String?){
        self.queryName = queryName
        self.queryLocation = queryLocation
        self.queryCompany = queryCompany
    }
    
    let baseURL = "http://104.154.45.194:80/search_n_recruit/contact/_search?from=0&size=50&q="
    
    
    func getURLString() -> String {
        // add name to query
        var url = baseURL + ("+fullName:\""+queryName+"\"").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        // add location to query
        url += ("+location:\"" + queryLocation + "\"").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        // add company to query if valid
        if let queryCompanyUnwrapped = queryCompany {
            url += ("+experience.organization.companyName:\"" + queryCompanyUnwrapped + "\"").addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        }
        return url
    }
    
    
    func getJSON(success: (([Candidate])->Void)?){
        Alamofire.request(getURLString(), headers: ["X-API-KEY": "ZWxhc3RpY3NlYXJjaC1xdWV1ZXRlY2hub2xvZ2llc2Rldg=="]).responseJSON { (responseData) -> Void in
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
                    
                    let candidate = Candidate(fullName: fullName!, location: location!, position: position!, company: company!, id: id!)
                    candidates.append(candidate)
                }
                success!(candidates)
            }
            
        }
    }
    
}
