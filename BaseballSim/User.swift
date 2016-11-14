//
//  User.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class User: NSObject , NSCoding
{
    var id:Int
    var first_name:String
    var last_name:String
    var username:String
    var email:String
    var date_created:String
    var auth_token:String
    var teams:[Team]
    var games:[Game]
    var approvals:[Approval]
    
    init(id:Int, first_name:String, last_name:String, username:String, email:String, date_created:String, auth_token:String, teams:[Team], games:[Game], approvals:[Approval])
    {        
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.username = username
        self.email = email
        self.date_created = date_created
        self.auth_token = auth_token
        self.teams = teams
        self.games = games
        self.approvals = approvals
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {        
        let id = aDecoder.decodeInteger(forKey: "id")
        let first_name = aDecoder.decodeObject(forKey: "first_name") as! String
        let last_name = aDecoder.decodeObject(forKey: "last_name") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        let auth_token = aDecoder.decodeObject(forKey: "auth_token") as! String
        let teams = aDecoder.decodeObject(forKey: "teams") as! [Team]
        let games = aDecoder.decodeObject(forKey: "games") as! [Game]
        let approvals = aDecoder.decodeObject(forKey: "approvals") as! [Approval]
        
        self.init(id:id, first_name:first_name, last_name:last_name, username:username, email:email, date_created:date_created, auth_token:auth_token, teams:teams, games:games, approvals:approvals)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.first_name, forKey: "first_name")
        aCoder.encode(self.last_name, forKey: "last_name")
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.date_created, forKey: "date_created")
        aCoder.encode(self.auth_token, forKey: "auth_token")
        aCoder.encode(self.teams, forKey: "teams")
        aCoder.encode(self.games, forKey: "games")
        aCoder.encode(self.games, forKey: "approvals")
    }
    
    func setTeams(id:Int, league_id:Int, name:String, date_created:String)
    {
        let team = Team(id: id, league_id: league_id, name: name, date_created: date_created)
        self.teams.append(team)
    }
    
    func setGames(id:Int, league_id:Int, field_id:Int, team1_id:Int, team2_id:Int, date_created:String)
    {
        let game = Game(id: id, league_id: league_id, field_id: field_id, team1_id: team1_id, team2_id: team2_id, date_created: date_created)
        self.games.append(game)
    }
    
    func setApprovals(id:Int, approved:String, item_id:Int, item_type:String, date_created:String)
    {
        let approval = Approval(id: id, approved: approved, item_id: item_id, item_type: item_type, date_created: date_created)
        self.approvals.append(approval)
    }
    
}
