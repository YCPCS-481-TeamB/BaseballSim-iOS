//
//  User.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class User
{
    var id:Int
    var first_name:String
    var last_name:String
    var username:String
    var email:String
    var date_created:Date
    var auth_token:String
    
    init(id:Int, first_name:String, last_name:String, username:String, email:String, date_created:Date, auth_token:String)
    {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.username = username
        self.email = email
        self.date_created = date_created
        self.auth_token = auth_token
    }
    
}
