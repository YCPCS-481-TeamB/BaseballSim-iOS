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
    var requests:Request
    var apiUrl:String!
    var loginUrls:[String]!
    var loginParams:[String:String]!
    var loginHeaders:[String:String]!
    var dataParams:[String:String]!
    var dataHeaders:[String:String]!
    var error:String!
    var userInformation:[String:String]!
    var user:User
    
    init()
    {
        self.requests = Request()
        self.apiUrl = "https://baseballsim-koopaluigi.c9users.io/api/"      //Testing
        //self.apiUrl = "https://baseballsim.herokuapp.com/api/"            //Heroku
        self.loginUrls = ["users/token", "users", "teams", "games"]
        self.loginParams = ["username":"koopaluigi", "password":"toadstool"]
        self.loginHeaders = [:]
        self.dataParams = [:]
        self.dataHeaders = ["x-access-token":""]
        self.error = ""
        self.userInformation = [:]
        self.user = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [])
    }
    
    func getUser() -> User
    {
        return self.user
    }
    
        
    //Go through the http requests to get all the information for login
    func login(username:String, password:String) -> String
    {
        let loginRequest = DispatchGroup.init()
        let dataRequest = DispatchGroup.init()
        
        //Gets token of user if user exists
        
        var url = apiUrl + loginUrls[0]
        loginParams.updateValue(username, forKey: "username")
        loginParams.updateValue(password, forKey: "password")
        
        loginRequest.enter()
        
        requests.postRequest(url: url, params: loginParams as [String : AnyObject]?, headers: loginHeaders, finished: {
            () in
            loginRequest.leave()
        })
        
        loginRequest.wait()
        
        //If unsuccessful login return error
        if(requests.postDictionary.value(forKey: "success") as! Bool == false)
        {
            self.error = requests.postDictionary.value(forKey: "error") as! String!
            return error
        }
        
        dataHeaders["x-access-token"] = requests.postDictionary.value(forKey: "token") as! String?
        
        //Get basic user information
        url = apiUrl + loginUrls[1]
        
        dataRequest.enter()
        
        requests.getRequest(url: url, params: dataParams as [String : AnyObject], headers: dataHeaders) {
            () in
            dataRequest.leave()
        }
        
        dataRequest.wait()
        
        
        let val = requests.getDictionary.value(forKey: "users")! as AnyObject
        
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
                
                user =  User(id: id, first_name: firstname, last_name: lastname, username: username, email: email, date_created: date_created, auth_token: auth_token, teams:[], games:[])
            }
 
        }
 
        //Request rest of user's information
        for dataUrl in self.loginUrls
        {
            if(dataUrl != "users/token" && dataUrl != "users")
            {
                dataRequest.enter()
                
                url = self.apiUrl + "users/\(user.id)/" + dataUrl
                
                requests.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
                    () in
                    dataRequest.leave()
                })
            }
            
            dataRequest.wait()
            
            if(dataUrl == "teams" && (requests.getDictionary["teams"]! as AnyObject).count != 0)
            {
                let teamVal = requests.getDictionary.value(forKey: "teams")! as AnyObject
                
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
 
            if(dataUrl == "games" && (requests.getDictionary["games"]! as AnyObject).count != 0)
            {
                let gameVal = requests.getDictionary.value(forKey: "games")! as AnyObject
                
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
