//
//  UserService.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation
import UIKit

class UserService
{
    var settings:Settings!
    
    init()
    {
        self.settings = Settings()
    }
    
    func getRequest(url:String, params: [String:AnyObject])
    {
        let thisUrl = URL(string: url)
        
        var request = URLRequest(url: thisUrl!)
        
        request.httpMethod = "GET"
        
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJrb29wYWx1aWdpIiwicGFzc3dvcmQiOiIkMmEkMTAkeldlNFdVcG4vLi5yWTdpeU90YXliT0ZncGVkLjNJbG5IWVhtdHBBYTA1OUZmQXpmVUtBaWkiLCJmaXJzdG5hbWUiOiJDb29wZXIiLCJsYXN0bmFtZSI6Ikx1ZXRqZSIsImVtYWlsIjoia29vcGFsdWlnaUBob3RtYWlsLmNvbSIsImRhdGVfY3JlYXRlZCI6IjIwMTYtMTAtMDNUMTY6MTM6NDguMjgwWiIsImlhdCI6MTQ3NjE1NjMyNH0.va7_WXrC6B7ngIUl-cp4qqCus8C0GViKnsG_LMw2_Ss", forHTTPHeaderField: "x-access-token")
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            //Check for an error
            if error != nil
            {
                print("Error: \(error)")
                return
            }
            
            //Print out the response from the server
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            //Convert json into NSDictionary
            do
            {
                if let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                {
                    print(jsonDict)
                    
                    //let firstNameValue = jsonDict["username"] as? String
                    //print(firstNameValue!)
                }
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }

}
