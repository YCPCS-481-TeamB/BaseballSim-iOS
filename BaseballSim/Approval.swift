//
//  Approval.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/7/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class Approval: NSObject, NSCoding
{
    var id:Int
    var approved:String
    var item_id:Int
    var item_type:String
    var date_created:String
    
    init(id:Int, approved:String, item_id:Int, item_type:String, date_created:String)
    {
        self.id = id
        self.approved = approved
        self.item_id = item_id
        self.item_type = item_type
        self.date_created = date_created
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let approved = aDecoder.decodeObject(forKey: "approved") as! String
        let item_id = aDecoder.decodeInteger(forKey: "item_id")
        let item_type = aDecoder.decodeObject(forKey: "item_type") as! String
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        
        self.init(id:id, approved:approved, item_id:item_id, item_type:item_type, date_created:date_created)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.approved, forKey: "approved")
        aCoder.encode(self.item_id, forKey: "item_id")
        aCoder.encode(self.item_type, forKey: "item_type")
        aCoder.encode(self.date_created, forKey: "date_created")
    }
    
    func printVals()
    {
        
    }
}
