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
    var user:Users
    var team:Teams
    var game:Games
    
    struct Users
    {
        //let.api = "https://baseballsim-koopaluigi.c9users.io/api/users"       //Testing
        let api = "https://baseballsim.herokuapp.com/api/users"                 //Heroku
        
        var getUsers:String         // GET      ()          ()
        var getUserTeams:String     // GET      (use id)    ()
        var getUserGames:String     // GET      (use id)    ()
        var createUser:String       // POST     ()          (username, password, firstname, lastname, email)
        var token:String            // POST     ()          (username, password)
        var validate:String         // POST     ()          (token)
        var deleteUserById:String   // DELETE   (use id)    ()
        
        init()
        {
            getUsers = api + "/"
            getUserTeams = api + "/teams"
            getUserGames = api + "/games"
            createUser = api + "/"
            token = api + "/token"
            validate = api + "/validate"
            deleteUserById = api + "/"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct Teams
    {
        //let.api = "https://baseballsim-koopaluigi.c9users.io/api/teams"       //Testing
        let api = "https://baseballsim.herokuapp.com/api/teams"                 //Heroku
        
        var allTeams:String           // GET      ()          ()
        var createTeam:String           // POST     ()          (Team name, League Id)
        var updateTeamById:String       // POST     (use id)    (Team name)
        var getTeamById:String          // GET      (use id)
        var deleteTeamById:String       // DELETE   (use id)
        var getPlayersByTeamId:String   // GET      (use id)
        
        init()
        {
            allTeams = api + "/"
            createTeam = api + "/"
            updateTeamById = api + "/"
            getTeamById = api + "/"
            deleteTeamById = api + "/"
            getPlayersByTeamId = api + "/players"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct Games
    {
        //let.api = "https://baseballsim-koopaluigi.c9users.io/api/games"       //Testing
        let api = "https://baseballsim.herokuapp.com/api/games"                 //Heroku
        
        //var allTeams:String             // GET      ()          ()
        var createGame:String           // POST     ()          (Team name, League Id)
        /*
        var updateTeamById:String       // POST     (use id)    (Team name)
        var getTeamById:String          // GET      (use id)
        var deleteTeamById:String       // DELETE   (use id)
        var getPlayersByTeamId:String   // GET      (use id)
        */
        init()
        {
            //allTeams = api + "/"
            createGame = api + "/"
            /*
            updateTeamById = api + "/"
            getTeamById = api + "/"
            deleteTeamById = api + "/"
            getPlayersByTeamId = api + "/players"
             */
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    init()
    {
        self.user = Users()
        self.team = Teams()
        self.game = Games()
    }
}
