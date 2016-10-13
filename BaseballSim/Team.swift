//
//  Team.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/12/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class Team: NSObject, NSCoding
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
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let league_id = aDecoder.decodeInteger(forKey: "league_id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        
        self.init(id:id, league_id:league_id, name:name, date_created:date_created)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.league_id, forKey: "league_id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date_created, forKey: "date_created")
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
