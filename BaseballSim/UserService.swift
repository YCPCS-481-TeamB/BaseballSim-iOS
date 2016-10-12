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
    var getDictionary:NSDictionary!
    var postDictionary:NSDictionary!
    var apiUrl:String!
    var loginUrls:[String]!
    var loginParams:[String:String]!
    var loginHeaders:[String:String]!
    var dataParams:[String:String]!
    var dataHeaders:[String:String]!
    var error:String!
    var userInformation:[String:String]!
    
    init()
    {
        self.settings = Settings()
        self.getDictionary = [:]
        self.postDictionary = [:]
        self.apiUrl = "https://baseballsim-koopaluigi.c9users.io/api/"
        self.loginUrls = ["users/token", "teams", "games"]
        self.loginParams = ["username":"koopaluigi", "password":"toadstool"]
        self.loginHeaders = [:]
        self.dataParams = [:]
        self.dataHeaders = ["x-access-token":""]
        self.error = ""
        self.userInformation = [:]
    }
    
    func getRequest(url:String, params: [String:AnyObject], headers: [String:String]?, finished: @escaping () -> Void)
    {
        guard let thisUrl = URL(string: url) else
        {
            print("Error: URL is invalid")
            return
        }
        
        var request = URLRequest(url: thisUrl)
        
        request.httpMethod = "GET"
        
        for header in headers!
        {
            request.addValue(header.value, forHTTPHeaderField: header.key)
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
            
            var get:NSDictionary = [:]
            
            //Convert json into NSDictionary
            do
            {
                get = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            self.getDictionary = get
            print(self.getDictionary)
            
            finished()
        }
        
        task.resume()
    }
    
    func postRequest(url:String, params: [String:AnyObject]?, headers: [String:String]?, finished: @escaping () -> Void)
    {
        guard let thisUrl = URL(string: url) else
        {
            print("Error: URL is invalid")
            return
        }
        
        var request = URLRequest(url: thisUrl)
        
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
            data, response, error -> Void in
            
            //Check for an error
            if error != nil
            {
                print("Error in POST: \(error)")
                return
            }
            
            /*
            //Print out the response from the server for debugging
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            */
            
            var post:NSDictionary = [:]
            
            //Convert json into NSDictionary
            do
            {
                post = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            self.postDictionary = post
            print(self.postDictionary)
            
            //Task is finished
            finished()
        }
        
        task.resume()
        
    }
    
    //Go through the http requests to get all the information for login
    func login(username:String, password:String) -> String
    {
        let loginRequest = DispatchGroup.init()
        let dataRequest = DispatchGroup.init()
        
        //service.getRequest(url: url, params: params, headers: headers)
        
        //Gets token of user if user exists
        
        var url = apiUrl + loginUrls[0]
        loginParams.updateValue(username, forKey: "username")
        loginParams.updateValue(password, forKey: "password")
        
        loginRequest.enter()
        
        postRequest(url: url, params: loginParams as [String : AnyObject]?, headers: loginHeaders, finished: {
            () in
            loginRequest.leave()
        })        
        
        loginRequest.wait()
        
        //If unsuccessful login return error
        if(self.postDictionary.value(forKey: "success") as! Bool == false)
        {
            self.error = self.postDictionary.value(forKey: "error") as! String!
            return error
        }
        
        dataHeaders["x-access-token"] = self.postDictionary.value(forKey: "token") as! String?
        
        //Request user's information
        for dataUrl in self.loginUrls
        {
            if(url != "users/token")
            {
                dataRequest.enter()
                
                url = self.apiUrl + dataUrl
                
                self.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
                    () in
                    dataRequest.leave()
                })
            }
            
            dataRequest.wait()
            
            for (key, value) in self.getDictionary
            {
                self.userInformation[key as! String] = value as? String
            }
            print("Dictionary:\(self.getDictionary)")
        }
        
        return ""
    }
    
    func getGetDictionary() -> NSDictionary
    {
        return getDictionary
    }
    
    func getPostDictionary() -> NSDictionary
    {
        return postDictionary
    }

}
