//
//  GamePosition.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/11/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class GamePosition: NSObject, NSCoding
{
    var id:Int
    var game_action_id:Int
    var onfirst_id:Int
    var onsecond_id:Int
    var onthird_id:Int
    var date_created:String
    
    init(id:Int, game_action_id:Int, onfirst_id:Int, onsecond_id:Int, onthird_id:Int, date_created:String)
    {
        self.id = id
        self.game_action_id = game_action_id
        self.onfirst_id = onfirst_id
        self.onsecond_id = onsecond_id
        self.onthird_id = onthird_id
        self.date_created = date_created
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let game_action_id = aDecoder.decodeInteger(forKey: "game_action_id")
        let onfirst_id = aDecoder.decodeInteger(forKey: "onfirst_id")
        let onsecond_id = aDecoder.decodeInteger(forKey: "onsecond_id")
        let onthird_id = aDecoder.decodeInteger(forKey: "onthird_id")
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        
        self.init(id:id, game_action_id:game_action_id, onfirst_id:onfirst_id, onsecond_id:onsecond_id, onthird_id:onthird_id, date_created:date_created)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.game_action_id, forKey: "game_action_id")
        aCoder.encode(self.onfirst_id, forKey: "onfirst_id")
        aCoder.encode(self.onsecond_id, forKey: "onsecond_id")
        aCoder.encode(self.onthird_id, forKey: "onthird_id")
        aCoder.encode(self.date_created, forKey: "date_created")
    }
    
    func printVals()
    {
        
    }
}
