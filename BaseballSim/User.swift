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
    var date_created:String
    var auth_token:String
    var teams:[Team]
    var games:[Game]
    
    init(id:Int, first_name:String, last_name:String, username:String, email:String, date_created:String, auth_token:String)
    {
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.username = username
        self.email = email
        self.date_created = date_created
        self.auth_token = auth_token
        self.teams = []
        self.games = []
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
    
    func printVals()
    {
        print("Here is your user!")
        print(id)
        print(first_name)
        print(last_name)
        print(username)
        print(email)
        print(date_created)
        print(auth_token)
        if(teams.count != 0)
        {
            for i in 0...teams.count-1
            {
                teams[i].printVals()
            }
        }
        if(games.count != 0)
        {
            for i in 0...games.count-1
            {
                games[i].printVals()
            }
        }
    }
    
}
