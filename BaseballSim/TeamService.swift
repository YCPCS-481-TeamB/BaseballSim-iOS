//
//  TeamService.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/13/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class TeamService
{
    var apiUrl:ApiRoutes
    var requests:Request
    //var apiUrl:String!
    var params:[String:String]!
    var headers:[String:String]!
    var error:String!
    var auth_token:String
    
    init(auth_token:String)
    {
        self.apiUrl = ApiRoutes()
        self.requests = Request()
        //self.apiUrl = "https://baseballsim-koopaluigi.c9users.io/api/"      //Testing
        //self.apiUrl = "https://baseballsim.herokuapp.com/api/"            //Heroku
        self.params = [:]
        self.auth_token = auth_token
        self.headers = ["x-access-token":auth_token]
        self.error = ""
    }
    
    func addPlayer(name:String, league_id:String)
    {
        let request = DispatchGroup.init()
        
        //Gets token of user if user exists
        
        //let url = apiUrl.api + "/teams/"
        let url = "https://baseballsim-koopaluigi.c9users.io/api/teams/"
        print("URL: \(url)")
        params = ["teamname": name, "league_id" : league_id]
        
        request.enter()
        
        requests.postRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
    }
}
