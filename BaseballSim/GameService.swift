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
        // If games exist in the returned data from POST
        if requests.postDictionary["game"] != nil && (requests.postDictionary["game"]! as AnyObject).count != 0
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
    
    func startGame(game:Game)
    {
        let game_id = game.id
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.startGame
        
        //Add id to url
        let gameId = ("/" + String(game_id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //params = []
        
        request.enter()
        
        requests.postRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
    }
    
    func nextEvent(game:Game)
    {
        let game_id = game.id
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.nextEvent
        
        //Add id to url
        let gameId = ("/" + String(game_id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //player1 and player2 ids
        //params = []
        
        request.enter()
        
        requests.postRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
    }
    
    func getLatestPosition(game:Game) -> GamePosition
    {
        var gamePosition:GamePosition = GamePosition(id: -1, game_action_id: -1, onfirst_id: -1, onsecond_id: -1, onthird_id: -1, date_created: "")
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.getLatestPositions
        
        //Add id to url
        let gameId = ("/" + String(game.id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //params = []
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If games exist in the returned data from GET
        if requests.getDictionary["positions"] != nil && (requests.getDictionary["positions"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "positions")! as AnyObject
            let id = val.value(forKey: "id")! as! Int
            let game_action_id = val.value(forKey: "game_action_id")! as! Int
            let onfirst_id = val.value(forKey: "onfirst_id")! as! Int
            let onsecond_id = val.value(forKey: "onsecond_id")! as! Int
            let onthird_id = val.value(forKey: "onthird_id")! as! Int
            let date_created = val.value(forKey: "date_created")! as! String
            gamePosition = GamePosition(id: id, game_action_id: game_action_id, onfirst_id: onfirst_id, onsecond_id: onsecond_id, onthird_id: onthird_id, date_created: date_created)
        }
        return gamePosition
        
    }
    
    func getLatestEvent(game:Game) -> GameAction
    {
        var gameAction:GameAction = GameAction(id: -1, game_id: -1, team_at_bat: -1, team1_score: -1, team2_score: -1, balls: -1, strikes: -1, outs: -1, inning: -1, type: "", message: "", date_created: "")
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.getLatestEvent
        
        //Add id to url
        let gameId = ("/" + String(game.id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //params = []
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If games exist in the returned data from GET
        if requests.getDictionary["events"] != nil && (requests.getDictionary["events"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "events")! as AnyObject
            let id = val.value(forKey: "id")! as! Int
            let game_id = val.value(forKey: "game_id")! as! Int
            let team_at_bat = val.value(forKey: "team_at_bat")! as! Int
            let team1_score = val.value(forKey: "team1_score")! as! Int
            let team2_score = val.value(forKey: "team2_score")! as! Int
            let balls = val.value(forKey: "balls")! as! Int
            let strikes = val.value(forKey: "strikes")! as! Int
            let outs = val.value(forKey: "outs")! as! Int
            let inning = val.value(forKey: "inning")! as! Int
            let type = val.value(forKey: "type")! as! String
            let message = val.value(forKey: "message")! as! String
            let date_created = val.value(forKey: "date_created")! as! String
            gameAction = GameAction(id: id, game_id: game_id, team_at_bat: team_at_bat, team1_score: team1_score, team2_score: team2_score, balls: balls, strikes: strikes, outs: outs, inning: inning, type: type, message: message, date_created: date_created)
        }
        return gameAction
        
    }
    
    func getEvents(game:Game) -> [GameAction]
    {
        let game_id = game.id
        var gameAction:GameAction = GameAction(id: -1, game_id: -1, team_at_bat: -1, team1_score: -1, team2_score: -1, balls: -1, strikes: -1, outs: -1, inning: -1, type: "", message: "", date_created: "")
        var gameEvents:[GameAction] = []
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.getAllEvents
        
        //Add id to url
        let gameId = ("/" + String(game_id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //params = []
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If games exist in the returned data from GET
        if requests.getDictionary["events"] != nil && (requests.getDictionary["events"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "events")! as AnyObject
            for i in 0...(val.count-1)
            {
                let innerVal = val[i]! as AnyObject
                
                let id = innerVal.value(forKey: "id")! as! Int
                let game_id = innerVal.value(forKey: "game_id")! as! Int
                let team_at_bat = innerVal.value(forKey: "team_at_bat")! as! Int
                let team1_score = innerVal.value(forKey: "team1_score")! as! Int
                let team2_score = innerVal.value(forKey: "team2_score")! as! Int
                let balls = innerVal.value(forKey: "balls")! as! Int
                let strikes = innerVal.value(forKey: "strikes")! as! Int
                let outs = innerVal.value(forKey: "outs")! as! Int
                let inning = innerVal.value(forKey: "inning")! as! Int
                let type = innerVal.value(forKey: "type")! as! String
                let message = innerVal.value(forKey: "message")! as! String
                let date_created = innerVal.value(forKey: "date_created")! as! String
                gameAction = GameAction(id: id, game_id: game_id, team_at_bat: team_at_bat, team1_score: team1_score, team2_score: team2_score, balls: balls, strikes: strikes, outs: outs, inning: inning, type: type, message: message, date_created: date_created)
                gameEvents.append(gameAction)
            }
        }
        
        return gameEvents
        
    }
    
    func isGameApproved(game_id:Int) ->Bool
    {
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.getGameApproval
        
        //Add id to url
        let gameId = ("/" + String(game_id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //params = []
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If games exist in the returned data from GET
        if requests.getDictionary["approvals"] != nil && (requests.getDictionary["approvals"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "approvals")! as AnyObject
            for i in 0...(val.count-1)
            {
                let innerVal = val[i]! as AnyObject
                
                let approved = innerVal.value(forKey: "approved") as! String
                if(approved == "approved")
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isGameDeclined(game_id:Int) ->Bool
    {
        
        let request = DispatchGroup.init()
        
        var url = apiRoutes.game.getGameApproval
        
        //Add id to url
        let gameId = ("/" + String(game_id)).characters.reversed()
        
        for i in gameId.indices
        {
            url.insert(gameId[i], at: apiRoutes.game.indexForId())
        }
        
        //params = []
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If games exist in the returned data from GET
        if requests.getDictionary["approvals"] != nil && (requests.getDictionary["approvals"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "approvals")! as AnyObject
            for i in 0...(val.count-1)
            {
                let innerVal = val[i]! as AnyObject
                
                let approved = innerVal.value(forKey: "approved") as! String
                if(approved == "declined")
                {
                    return true
                }
            }
        }
        
        return false
    }
    
}
