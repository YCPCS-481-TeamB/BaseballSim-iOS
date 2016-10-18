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
    var apiRoutes:ApiRoutes
    var requests:Request
    var params:[String:String]!
    var headers:[String:String]!
    var error:String!
    var auth_token:String
    
    init(auth_token:String)
    {
        self.apiRoutes = ApiRoutes()
        self.requests = Request()
        self.params = [:]
        self.auth_token = auth_token
        self.headers = ["x-access-token":auth_token]
        self.error = ""
    }
    
    func addTeam(name:String, league_id:String) -> Team
    {
        var team = Team(id: -1, league_id: -1, name: "", date_created: "")
        
        let request = DispatchGroup.init()
        
        let url = apiRoutes.team.createTeam
        
        params = ["teamname": name, "league_id" : league_id]
        
        request.enter()
        
        requests.postRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        // If teams exist in the returned data from POST
        if (requests.postDictionary["teams"]! as AnyObject).count != 0
        {
            let val = requests.postDictionary.value(forKey: "teams")! as AnyObject
            let id = val.value(forKey: "id") as! Int
            let league_id = val.value(forKey: "league_id")! as! Int
            let name = val.value(forKey: "name") as! String
            let date_created = val.value(forKey: "date_created") as! String
            team = Team(id: id, league_id: league_id, name: name, date_created: date_created)
        }
        return team
    }
}
