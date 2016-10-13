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
    var user:User!
    
    init()
    {
        self.settings = Settings()
        self.getDictionary = [:]
        self.postDictionary = [:]
        self.apiUrl = "https://baseballsim-koopaluigi.c9users.io/api/"      //Testing
        //self.apiUrl = "https://baseballsim.herokuapp.com/api/"            //Heroku
        self.loginUrls = ["users/token", "users", "teams", "games"]
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
                get = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            self.getDictionary = get
            
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
        
        //Get basic user information
        url = apiUrl + loginUrls[1]
        
        dataRequest.enter()
        
        getRequest(url: url, params: dataParams as [String : AnyObject], headers: dataHeaders) { 
            () in
            dataRequest.leave()
        }
        
        dataRequest.wait()
        
        
        let val = getDictionary.value(forKey: "users")! as AnyObject
        
        //Find user within user
        for i in 0...(val.count-1)
        {
            
            let innerVal = val[i]! as AnyObject
            //If user is found create user
            if(innerVal.value(forKey: "username") as! String == username)
            {
                //Set user information
                let id = innerVal.value(forKey: "id") as! Int
                let firstname = innerVal.value(forKey: "firstname") as! String
                let lastname = innerVal.value(forKey: "lastname") as! String
                let username = innerVal.value(forKey: "username") as! String
                let email = innerVal.value(forKey: "email") as! String
                let date_created = innerVal.value(forKey: "date_created") as! String
                let auth_token =  dataHeaders["x-access-token"]!
                
                user =  User(id: id, first_name: firstname, last_name: lastname, username: username, email: email, date_created: date_created, auth_token: auth_token)
            }
 
        }
 
        //Request rest of user's information
        for dataUrl in self.loginUrls
        {
            if(dataUrl != "users/token" || dataUrl != "users")
            {
                dataRequest.enter()
                
                url = self.apiUrl + "users/\(user.id)/" + dataUrl
                
                self.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
                    () in
                    dataRequest.leave()
                })
            }
            
            dataRequest.wait()
            
            if(dataUrl == "teams" && (getDictionary["teams"]! as AnyObject).count != 0)
            {
                let teamVal = getDictionary.value(forKey: "teams")! as AnyObject
                
                //Find user within user
                for i in 0...(teamVal.count-1)
                {
                    let innerVal = teamVal[i]! as AnyObject
                    
                    let id = innerVal.value(forKey: "id") as! Int
                    let league_id = innerVal.value(forKey: "league_id") as! Int
                    let name = innerVal.value(forKey: "name") as! String
                    let date_created = innerVal.value(forKey: "date_created") as! String
                    
                    user.setTeams(id: id, league_id: league_id, name: name, date_created: date_created)
                }
            }
            
            if(dataUrl == "games" && (getDictionary["games"]! as AnyObject).count != 0)
            {
                let gameVal = getDictionary.value(forKey: "games")! as AnyObject
                
                //Find user within user
                for i in 0...(gameVal.count-1)
                {
                    let innerVal = gameVal[i]! as AnyObject
                    
                    let id = innerVal.value(forKey: "id") as! Int
                    let league_id = innerVal.value(forKey: "league_id") as! Int
                    let field_id = innerVal.value(forKey: "field_id") as! Int
                    let team1_id = innerVal.value(forKey: "team1_id") as! Int
                    let team2_id = innerVal.value(forKey: "team2_id") as! Int
                    let date_created = innerVal.value(forKey: "date_created") as! String
                    
                    user.setGames(id: id, league_id: league_id, field_id: field_id, team1_id: team1_id, team2_id: team2_id, date_created: date_created)
                }
            }
            
        }
        user.printVals()
        return ""
    }

}
