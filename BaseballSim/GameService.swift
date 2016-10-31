//
//  GameService.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/30/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class GameService
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
    
    func addGame(team1_id:String, team2_id:String) -> Game
    {
        var game:Game = Game(id: -1, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
        
        let request = DispatchGroup.init()
        
        let url = apiRoutes.game.createGame
        
        params = ["team1_id" : team1_id, "team2_id" : team2_id, "field_id" : "0", "league_id" : "0"]
        
        request.enter()
        
        requests.postRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        // If teams exist in the returned data from POST
        if (requests.postDictionary["game"]! as AnyObject).count != 0
        {
            let val = requests.postDictionary.value(forKey: "game")! as AnyObject
            let id = val.value(forKey: "id") as! Int
            let league_id = val.value(forKey: "league_id")! as! Int
            let field_id = val.value(forKey: "field_id")! as! Int
            let team1_id = val.value(forKey: "team1_id")! as! Int
            let team2_id = val.value(forKey: "team2_id")! as! Int
            let date_created = val.value(forKey: "date_created") as! String
            game = Game(id: id, league_id: league_id, field_id: field_id, team1_id: team1_id, team2_id: team2_id, date_created: date_created)
        }
        return game
    }
}
