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
    
    func getRequest(url:String, params: [String:AnyObject], headers: [String:String]?)
    {
        let thisUrl = URL(string: url)
        
        var request = URLRequest(url: thisUrl!)
        
        request.httpMethod = "GET"
        
        for header in headers!
        {
            request.addValue(header.key, forHTTPHeaderField: header.value)
        }
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            //Check for an error
            if error != nil
            {
                print("Error in GET: \(error)")
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
                    
                    //let playerId = jsonDict["id"] as? String
                    //print(playerId!)
                }
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func postRequest(url:String, params: [String:AnyObject]?, headers: [String:String]?)
    {
        let thisUrl = URL(string: url)
        
        var request = URLRequest(url: thisUrl!)
        
        request.httpMethod = "POST"
        
        //Set parameters
        var body = ""
        //Combines parameters into string to be placed into the body
        for (i, param) in (params?.enumerated())!
        {
            body += "\(param.key)=\(param.value)"
            if i != (params?.count)!-1
            {
                body += "&"
            }
        }
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        for header in headers!
        {
            request.addValue(header.key, forHTTPHeaderField: header.value)
        }
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            //Check for an error
            if error != nil
            {
                print("Error in POST: \(error)")
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
