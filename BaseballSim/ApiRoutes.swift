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
    var approvals:Approvals
    
    struct Users
    {
        let api = "https://baseballsim-koopaluigi.c9users.io/api/users"       //Testing
        //let api = "https://baseballsim.herokuapp.com/api/users"                 //Heroku
        
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
        let api = "https://baseballsim-koopaluigi.c9users.io/api/teams"       //Testing
        //let api = "https://baseballsim.herokuapp.com/api/teams"                 //Heroku
        
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
        let api = "https://baseballsim-koopaluigi.c9users.io/api/games"       //Testing
        //let api = "https://baseballsim.herokuapp.com/api/games"                 //Heroku
        
        var createGame:String           // POST     ()          (Team name, League Id)
        var startGame:String            // POST     (use id)    ()
        var getLatestPositions:String   // GET      (use id)    ()
        var getAllEvents:String         // GET      (use id)    ()
        var getLatestEvent:String       // GET      (use id)    ()
        var getGameApproval:String      // GET      (use id)    ()
        var nextEvent:String            // POST     (use id)    ()
        
        init()
        {
            createGame = api + "/"
            startGame = api + "/start"
            getLatestPositions = api + "/positions/latest"
            getAllEvents = api + "/events"
            getLatestEvent = api + "/events/latest"
            getGameApproval = api + "/approvals/state"
            nextEvent = api + "/events/next"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct Approvals
    {
        let api = "https://baseballsim-koopaluigi.c9users.io/api/approvals"       //Testing
        //let api = "https://baseballsim.herokuapp.com/api/approvals"                 //Heroku
        
        //var allTeams:String             // GET      ()          ()
        var getApprovals:String           // GET      ()          ()
        var approveApprovals:String
        /*
         var updateTeamById:String       // POST     (use id)    (Team name)
         var getTeamById:String          // GET      (use id)
         var deleteTeamById:String       // DELETE   (use id)
         var getPlayersByTeamId:String   // GET      (use id)
         */
        init()
        {
            //allTeams = api + "/"
            getApprovals = api + "/user/pending"
            approveApprovals = api + "/status"
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
        self.approvals = Approvals()
    }
}
