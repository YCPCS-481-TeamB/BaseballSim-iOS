//
//  Game.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/12/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class Game
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
