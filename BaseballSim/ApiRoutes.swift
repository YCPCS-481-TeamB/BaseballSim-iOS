//
//  ApiRoutes.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/13/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class ApiRoutes
{
    var api:String
    var user:Users
    var team:Teams
    
    struct Users
    {
        let getUsers:String = "/"                      // GET      ()          ()
        let getUserTeams:String = "/teams"             // GET      (use id)    ()
        let getUserGames:String = "/games"             // GET      (use id)    ()
        let createUser:String = "/"                    // POST     ()          (username, password, firstname, lastname, email)
        let token:String = "/token"                    // POST     ()          (username, password)
        let validate:String = "/validate"              // POST     ()          (token)
        let deleteUserById:String = "/"                // DELETE   (use id)    ()
    }
    
    struct Teams
    {
        let allPlayers:String = "/"                    // GET      ()          ()
        let createTeam:String = "/"                    // POST     ()          (Team name, League Id)
        let updateTeamById:String = "/"                // POST     (use id)    (Team name)
        let getTeamById:String = "/"                   // GET      (use id)
        let deleteTeamById:String = "/"                // DELETE   (use id)
        let getPlayersByTeamId:String = "/players"     // GET
    }
    
    init()
    {
        self.api = "https://baseballsim-koopaluigi.c9users.io/api"      //Testing
        //self.api = "https://baseballsim.herokuapp.com/api"            //Heroku
        self.user = Users()
        self.team = Teams()
    }
}
