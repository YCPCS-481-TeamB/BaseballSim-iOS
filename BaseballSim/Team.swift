//
//  Team.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/12/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class Team
{
    var id:Int
    var league_id:Int
    var name:String
    var date_created:String
    
    init(id:Int, league_id:Int, name:String, date_created:String)
    {
        self.id = id
        self.league_id = league_id
        self.name = name
        self.date_created = date_created
    }
    
    func printVals()
    {
        print("Team \(id)")
        print(id)
        print(league_id)
        print(name)
        print(date_created)
    }
}
