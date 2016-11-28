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
    var apiRoutes:ApiRoutes
    var loginUrls:[String]!
    var loginParams:[String:String]!
    var signUpParams:[String:String]!
    var loginHeaders:[String:String]!
    var dataParams:[String:String]!
    var dataHeaders:[String:String]!
    var error:String!
    var userInformation:[String:String]!
    var user:User
    
    init()
    {
        self.requests = Request()
        self.apiRoutes = ApiRoutes()
        self.loginUrls = ["users/token", "users", "teams", "games"]
        self.loginParams = ["username":"koopaluigi", "password":"toadstool"]
        self.signUpParams = ["username":"", "password":"", "firstname":"", "lastname":"", "email":""]
        self.loginHeaders = [:]
        self.dataParams = [:]
        self.dataHeaders = ["x-access-token":""]
        self.error = ""
        self.userInformation = [:]
        self.user = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    }
    
    func getUser() -> User
    {
        return self.user
    }
    
        
    //Go through the http requests to get all the information for login
    func login(username:String, password:String) -> String
    {
        //False login if username or password is empty, return error
        if username == ""
        {
            self.error = "You must enter a username!"
            return error
        }
        if password == ""
        {
            self.error = "You must enter a password!"
            return error
        }
        let loginRequest = DispatchGroup.init()
        let dataRequest = DispatchGroup.init()
        
        //Gets token of user if user exists
        
        var url = apiRoutes.user.token
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
        url = apiRoutes.user.getUsers
        
        dataRequest.enter()
        
        requests.getRequest(url: url, params: dataParams as [String : AnyObject], headers: dataHeaders){
            () in
            dataRequest.leave()
        }
        
        dataRequest.wait()
        
        
        let val = requests.getDictionary.value(forKey: "users")! as AnyObject
        
        //Find user within user
        for i in 0...(val.count-1)
        {
            
            let innerVal = (val as! NSArray)[i] as AnyObject
            
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
                
                user =  User(id: id, first_name: firstname, last_name: lastname, username: username, email: email, date_created: date_created, auth_token: auth_token, teams:[], games:[], approvals: [])
            }
 
        }
 
        //Request rest of user's information
        
        //Request teams
        dataRequest.enter()
                
        url = apiRoutes.user.getUserTeams
        
        //Add id to url
        let userId = ("/" + String(user.id)).characters.reversed()
        
        for i in userId.indices
        {
            url.insert(userId[i], at: apiRoutes.user.indexForId())
        }
        
        requests.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
            () in
            dataRequest.leave()
        })
            
        dataRequest.wait()
            
        if((requests.getDictionary["teams"]! as AnyObject).count != 0)
        {
            let teamVal = requests.getDictionary.value(forKey: "teams")! as AnyObject
                
            //Find user within user
            for i in 0...(teamVal.count-1)
            {
                let innerVal = (teamVal as! NSArray)[i] as AnyObject
                    
                let id = innerVal.value(forKey: "id") as! Int
                let league_id = innerVal.value(forKey: "league_id") as! Int
                let name = innerVal.value(forKey: "name") as! String
                let date_created = innerVal.value(forKey: "date_created") as! String
                    
                user.setTeams(id: id, league_id: league_id, name: name, date_created: date_created)
            }
        }
        
        //Request games
        dataRequest.enter()
        
        url = apiRoutes.user.getUserGames
        
        //Add id to url
        for i in userId.indices
        {
            url.insert(userId[i], at: apiRoutes.user.indexForId())
        }
        
        requests.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
            () in
            dataRequest.leave()
        })
        
        dataRequest.wait()
 
        if((requests.getDictionary["games"]! as AnyObject).count != 0)
        {
            let gameVal = requests.getDictionary.value(forKey: "games")! as AnyObject
                
            //Find user within user
            for i in 0...(gameVal.count-1)
            {
                let innerVal = (gameVal as! NSArray)[i] as AnyObject
                    
                let id = innerVal.value(forKey: "id") as! Int
                let league_id = innerVal.value(forKey: "league_id") as! Int
                let field_id = innerVal.value(forKey: "field_id") as! Int
                let team1_id = innerVal.value(forKey: "team1_id") as! Int
                let team2_id = innerVal.value(forKey: "team2_id") as! Int
                let date_created = innerVal.value(forKey: "date_created") as! String
                    
                user.setGames(id: id, league_id: league_id, field_id: field_id, team1_id: team1_id, team2_id: team2_id, date_created: date_created)
            }
        }
        
        //user.printVals()
        return ""
    }
    
    func signUp(username:String, password:String, firstName:String, lastName:String, email:String)
    {
        /*
        //False login if username or password is empty, return error
        if username == ""
        {
            self.error = "You must enter a username!"
            return error
        }
        if password == ""
        {
            self.error = "You must enter a password!"
            return error
        }
        */
        let request = DispatchGroup.init()
        
        //Gets token of user if user exists
        
        let url = apiRoutes.user.createUser
        signUpParams.updateValue(username, forKey: "username")
        signUpParams.updateValue(password, forKey: "password")
        signUpParams.updateValue(firstName, forKey: "firstname")
        signUpParams.updateValue(lastName, forKey: "lastname")
        signUpParams.updateValue(email, forKey: "email")
        
        request.enter()
        
        requests.postRequest(url: url, params: signUpParams as [String : AnyObject]?, headers: loginHeaders, finished: {
            () in
            request.leave()
        })
        
        request.wait()
    }
    
    //Go through the http requests to get all the information for user data
    func getUserData(auth_token:String, username:String) -> User
    {
        let dataRequest = DispatchGroup.init()
        
        dataHeaders["x-access-token"] = auth_token
        
        //Get basic user information
        var url = apiRoutes.user.getUsers
        
        dataRequest.enter()
        
        requests.getRequest(url: url, params: dataParams as [String : AnyObject], headers: dataHeaders){
            () in
            dataRequest.leave()
        }
        
        dataRequest.wait()
        
        
        let val = requests.getDictionary.value(forKey: "users")! as AnyObject
        
        //Find user within user
        for i in 0...(val.count-1)
        {
            
            let innerVal = (val as! NSArray)[i] as AnyObject
            
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
                
                user =  User(id: id, first_name: firstname, last_name: lastname, username: username, email: email, date_created: date_created, auth_token: auth_token, teams:[], games:[], approvals: [])
            }
            
        }
        
        //Request rest of user's information
        
        //Request teams
        dataRequest.enter()
        
        url = apiRoutes.user.getUserTeams
        
        //Add id to url
        let userId = ("/" + String(user.id)).characters.reversed()
        
        for i in userId.indices
        {
            url.insert(userId[i], at: apiRoutes.user.indexForId())
        }
        
        requests.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
            () in
            dataRequest.leave()
        })
        
        dataRequest.wait()
        
        if((requests.getDictionary["teams"]! as AnyObject).count != 0)
        {
            let teamVal = requests.getDictionary.value(forKey: "teams")! as AnyObject
            
            //Find user within user
            for i in 0...(teamVal.count-1)
            {
                let innerVal = (teamVal as! NSArray)[i] as AnyObject
                
                let id = innerVal.value(forKey: "id") as! Int
                let league_id = innerVal.value(forKey: "league_id") as! Int
                let name = innerVal.value(forKey: "name") as! String
                let date_created = innerVal.value(forKey: "date_created") as! String
                
                user.setTeams(id: id, league_id: league_id, name: name, date_created: date_created)
            }
        }
        
        //Request games
        dataRequest.enter()
        
        url = apiRoutes.user.getUserGames
        
        //Add id to url
        for i in userId.indices
        {
            url.insert(userId[i], at: apiRoutes.user.indexForId())
        }
        
        requests.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
            () in
            dataRequest.leave()
        })
        
        dataRequest.wait()
        
        if((requests.getDictionary["games"]! as AnyObject).count != 0)
        {
            let gameVal = requests.getDictionary.value(forKey: "games")! as AnyObject
            
            //Find user within user
            for i in 0...(gameVal.count-1)
            {
                let innerVal = (gameVal as! NSArray)[i] as AnyObject
                
                let id = innerVal.value(forKey: "id") as! Int
                let league_id = innerVal.value(forKey: "league_id") as! Int
                let field_id = innerVal.value(forKey: "field_id") as! Int
                let team1_id = innerVal.value(forKey: "team1_id") as! Int
                let team2_id = innerVal.value(forKey: "team2_id") as! Int
                let date_created = innerVal.value(forKey: "date_created") as! String
                
                user.setGames(id: id, league_id: league_id, field_id: field_id, team1_id: team1_id, team2_id: team2_id, date_created: date_created)
            }
        }
        
        user.auth_token = auth_token
        
        return user
    }
    
    func getUserTeams(user_id:Int) -> [Team]
    {
        var teams:[Team] = []
        let request = DispatchGroup.init()
        
        var url = apiRoutes.user.getUserTeams
        
        //Add id to url
        let userId = ("/" + String(user_id)).characters.reversed()
        
        for i in userId.indices
        {
            url.insert(userId[i], at: apiRoutes.user.indexForId())
        }
        
        request.enter()
        
        requests.getRequest(url: url, params: (dataParams as [String : AnyObject]?)!, headers: dataHeaders, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        if((requests.getDictionary["teams"]! as AnyObject).count != 0)
        {
            let teamVal = requests.getDictionary.value(forKey: "teams")! as AnyObject
            
            //Find user within user
            for i in 0...(teamVal.count-1)
            {
                let innerVal = (teamVal as! NSArray)[i] as AnyObject
                
                let id = innerVal.value(forKey: "id") as! Int
                let league_id = innerVal.value(forKey: "league_id") as! Int
                let name = innerVal.value(forKey: "name") as! String
                let date_created = innerVal.value(forKey: "date_created") as! String
                let team = Team(id: id, league_id: league_id, name: name, date_created: date_created)
                teams.append(team)
            }
        }
        
        return teams
    }
    
    func getUserGames(user_id:Int) -> [Game]
    {
        var games:[Game] = []
        let request = DispatchGroup.init()
        
        //Request games
        request.enter()
        
        var url = apiRoutes.user.getUserGames
        
        //Add id to url
        let userId = ("/" + String(user_id)).characters.reversed()
        
        for i in userId.indices
        {
            url.insert(userId[i], at: apiRoutes.user.indexForId())
        }
        
        requests.getRequest(url: url, params: self.dataParams as [String : AnyObject], headers: self.dataHeaders, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        if((requests.getDictionary["games"]! as AnyObject).count != 0)
        {
            let gameVal = requests.getDictionary.value(forKey: "games")! as AnyObject
            
            //Find user within user
            for i in 0...(gameVal.count-1)
            {
                let innerVal = (gameVal as! NSArray)[i] as AnyObject
                
                let id = innerVal.value(forKey: "id") as! Int
                let league_id = innerVal.value(forKey: "league_id") as! Int
                let field_id = innerVal.value(forKey: "field_id") as! Int
                let team1_id = innerVal.value(forKey: "team1_id") as! Int
                let team2_id = innerVal.value(forKey: "team2_id") as! Int
                let date_created = innerVal.value(forKey: "date_created") as! String
                let game = Game(id: id, league_id: league_id, field_id: field_id, team1_id: team1_id, team2_id: team2_id, date_created: date_created)
                games.append(game)
            }
        }
        return games
    }

}
