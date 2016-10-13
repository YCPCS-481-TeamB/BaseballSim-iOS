//
//  Game.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/12/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class Game: NSObject, NSCoding
{
    var id:Int
    var league_id:Int
    var field_id:Int
    var team1_id:Int
    var team2_id:Int
    var date_created:String
    
    init(id:Int, league_id:Int, field_id:Int, team1_id:Int, team2_id:Int, date_created:String)
    {
        self.id = id
        self.league_id = league_id
        self.field_id = field_id
        self.team1_id = team1_id
        self.team2_id = team2_id
        self.date_created = date_created
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let league_id = aDecoder.decodeInteger(forKey: "league_id")
        let field_id = aDecoder.decodeInteger(forKey: "field_id")
        let team1_id = aDecoder.decodeInteger(forKey: "team1_id")
        let team2_id = aDecoder.decodeInteger(forKey: "team2_id")
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        
        self.init(id:id, league_id:league_id, field_id:field_id, team1_id:team1_id, team2_id:team2_id, date_created:date_created)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.league_id, forKey: "league_id")
        aCoder.encode(self.field_id, forKey: "field_id")
        aCoder.encode(self.team1_id, forKey: "team1_id")
        aCoder.encode(self.team2_id, forKey: "team2_id")
        aCoder.encode(self.date_created, forKey: "date_created")
    }
    
    func printVals()
    {
        print("Game \(id)")
        print(id)
        print(league_id)
        print(field_id)
        print(team1_id)
        print(team2_id)
        print(date_created)
    }
}
