//
//  GameAction.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class GameAction: NSObject, NSCoding
{
    var id:Int
    var game_id:Int
    var team_at_bat:Int
    var team1_score:Int
    var team2_score:Int
    var balls:Int
    var strikes:Int
    var outs:Int
    var inning:Int
    var type:String
    var message:String
    var date_created:String
    
    init(id:Int, game_id:Int, team_at_bat:Int, team1_score:Int, team2_score:Int, balls:Int, strikes:Int, outs:Int, inning:Int, type:String, message:String, date_created:String)
    {
        self.id = id
        self.game_id = game_id
        self.team_at_bat = team_at_bat
        self.team1_score = team1_score
        self.team2_score = team2_score
        self.balls = balls
        self.strikes = strikes
        self.outs = outs
        self.inning = inning
        self.type = type
        self.message = message
        self.date_created = date_created
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let game_id = aDecoder.decodeInteger(forKey: "game_id")
        let team_at_bat = aDecoder.decodeInteger(forKey: "team_at_bat")
        let team1_score = aDecoder.decodeInteger(forKey: "team1_score")
        let team2_score = aDecoder.decodeInteger(forKey: "team2_score")
        let balls = aDecoder.decodeInteger(forKey: "balls")
        let strikes = aDecoder.decodeInteger(forKey: "strikes")
        let outs = aDecoder.decodeInteger(forKey: "outs")
        let inning = aDecoder.decodeInteger(forKey: "inning")
        let type = aDecoder.decodeObject(forKey: "type") as! String
        let message = aDecoder.decodeObject(forKey: "message") as! String
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        
        self.init(id:id, game_id:game_id, team_at_bat:team_at_bat, team1_score:team1_score, team2_score:team2_score, balls:balls, strikes:strikes, outs:outs, inning:inning, type:type, message:message, date_created:date_created)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.game_id, forKey: "game_id")
        aCoder.encode(self.team_at_bat, forKey: "team_at_bat")
        aCoder.encode(self.team1_score, forKey: "team1_score")
        aCoder.encode(self.team2_score, forKey: "team2_score")
        aCoder.encode(self.balls, forKey: "balls")
        aCoder.encode(self.strikes, forKey: "strikes")
        aCoder.encode(self.outs, forKey: "outs")
        aCoder.encode(self.inning, forKey: "inning")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.message, forKey: "message")
        aCoder.encode(self.date_created, forKey: "date_created")
    }
    
    func printVals()
    {
        
    }
}
