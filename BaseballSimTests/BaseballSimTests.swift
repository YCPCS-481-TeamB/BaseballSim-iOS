//
//  BaseballSimTests.swift
//  BaseballSimTests
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import XCTest
@testable import BaseballSim

class BaseballSimTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginSucceed()
    {
        let userService:UserService = UserService()
        let succeed = userService.login(username: "koopaluigi", password: "toadstool")
        XCTAssertTrue(succeed == "")
    }
    
    func testLoginFailure()
    {
        let userService:UserService = UserService()
        
        //Username not entered
        var failure = userService.login(username: "", password: "")
        XCTAssertTrue(failure == "You must enter a username!")
        
        //Password not entered
        failure = userService.login(username: "koopaluigi", password: "")
        XCTAssertTrue(failure == "You must enter a password!")
        
        //Incorrect username/password combination
        failure = userService.login(username: "koopaluigi", password: "notit")
        XCTAssertTrue(failure == "The Password Is Invalid")
    }
    
    func testGetUserSuccess()
    {
        let userService:UserService = UserService()
        
        //Login with correct credentials
        if userService.login(username: "koopaluigi", password: "toadstool") == ""
        {
            //User was found
            let user = userService.getUser()
            XCTAssertFalse(user.id == -1)
            XCTAssertFalse(user.first_name == "")
            XCTAssertFalse(user.last_name == "")
            XCTAssertFalse(user.username == "")
            XCTAssertFalse(user.email == "")
            XCTAssertFalse(user.date_created == "")
            XCTAssertFalse(user.auth_token == "")
            
            //Correct User was found
            XCTAssertTrue(user.username == "koopaluigi")
        }
    }
    
    func testGetUserFailure()
    {
        let userService:UserService = UserService()
        
        //Login with correct credentials
        if userService.login(username: "koopaluigi", password: "notit") == "The Password Is Invalid"
        {
            //User was found
            let user = userService.getUser()
            XCTAssertTrue(user.id == -1)
            XCTAssertTrue(user.first_name == "")
            XCTAssertTrue(user.last_name == "")
            XCTAssertTrue(user.username == "")
            XCTAssertTrue(user.email == "")
            XCTAssertTrue(user.date_created == "")
            XCTAssertTrue(user.auth_token == "")
        }
    }
    
    func testGameService()
    {
        let userService:UserService = UserService()
        
        //Login with correct credentials
        if userService.login(username: "koopaluigi", password: "toadstool") == ""
        {
            let user = userService.getUser()
            let gameService:GameService = GameService(auth_token: user.auth_token)
            let approvalService:ApprovalService = ApprovalService(auth_token: user.auth_token)
            
            if(user.teams.count >= 2)
            {
                //Add Game
                let game = gameService.addGame(team1_id: String(user.teams[0].id), team2_id: String(user.teams[1].id))
                XCTAssertFalse(game.id == -1)
                XCTAssertFalse(game.league_id == -1)
                XCTAssertFalse(game.field_id == -1)
                XCTAssertFalse(game.team1_id == -1)
                XCTAssertFalse(game.team2_id == -1)
                XCTAssertFalse(game.date_created == "")
                
                //Is Game Not Approved
                var isApproved = gameService.isGameApproved(game_id: game.id)
                XCTAssertFalse(isApproved)
                
                //Approve Game
                let approval = approvalService.getApprovals()[approvalService.getApprovals().count-1]
                approvalService.approve(id: String(approval.id))
                isApproved = gameService.isGameApproved(game_id: game.id)
                XCTAssertTrue(isApproved)
                
                //Is Game Declined
                let isDeclined = gameService.isGameDeclined(game_id: game.id)
                XCTAssertFalse(isDeclined)
                
                //Start Game
                gameService.startGame(game: game)
                var gameAction = gameService.getLatestEvent(game: game)
                XCTAssertTrue(gameAction.message == "Game Started!")
                
                //Next Event
                let lastGameAction = gameService.getLatestEvent(game: game)
                gameService.nextEvent(game: game)
                gameAction = gameService.getLatestEvent(game: game)
                XCTAssertFalse(gameAction.message == lastGameAction.message)
                
                //Get Latest Position
                let lastGamePosition = gameService.getLatestPosition(game: game)
                XCTAssertFalse(lastGamePosition.id == -1)
                XCTAssertFalse(lastGamePosition.game_action_id == -1)
                XCTAssertFalse(lastGamePosition.onfirst_id == -1)
                XCTAssertFalse(lastGamePosition.onsecond_id == -1)
                XCTAssertFalse(lastGamePosition.onthird_id == -1)
                XCTAssertFalse(lastGamePosition.date_created == "")
                
                //Get Lastest Event
                let lastGameEvent = gameService.getLatestEvent(game: game)
                XCTAssertFalse(lastGameEvent.id == -1)
                XCTAssertFalse(lastGameEvent.game_id == -1)
                XCTAssertFalse(lastGameEvent.team_at_bat == -1)
                XCTAssertFalse(lastGameEvent.team1_score == -1)
                XCTAssertFalse(lastGameEvent.team2_score == -1)
                XCTAssertFalse(lastGameEvent.balls == -1)
                XCTAssertFalse(lastGameEvent.strikes == -1)
                XCTAssertFalse(lastGameEvent.outs == -1)
                XCTAssertFalse(lastGameEvent.inning == -1)
                XCTAssertFalse(lastGameEvent.type == "")
                XCTAssertFalse(lastGameEvent.message == "")
                XCTAssertFalse(lastGameEvent.date_created == "")
                
                //Get All Events
                let events = gameService.getEvents(game: game)
                if events.count != 0
                {
                    for i in 0...(events.count-1)
                    {
                        XCTAssertFalse(events[i].id == -1)
                        XCTAssertFalse(events[i].game_id == -1)
                        XCTAssertFalse(events[i].team_at_bat == -1)
                        XCTAssertFalse(events[i].team1_score == -1)
                        XCTAssertFalse(events[i].team2_score == -1)
                        XCTAssertFalse(events[i].balls == -1)
                        XCTAssertFalse(events[i].strikes == -1)
                        XCTAssertFalse(events[i].outs == -1)
                        XCTAssertFalse(events[i].inning == -1)
                        XCTAssertFalse(events[i].type == "")
                        XCTAssertFalse(events[i].message == "")
                        XCTAssertFalse(events[i].date_created == "")
                    }
                }
                
                //Get User Games
                userService.getUserGames(user_id: user.id)
                let games = user.games
                if games.count != 0
                {
                    for i in 0...(games.count-1)
                    {
                        XCTAssertFalse(games[i].id == -1)
                        XCTAssertFalse(games[i].league_id == -1)
                        XCTAssertFalse(games[i].field_id == -1)
                        XCTAssertFalse(games[i].team1_id == -1)
                        XCTAssertFalse(games[i].team2_id == -1)
                        XCTAssertFalse(games[i].date_created == "")
                    }
                }
            }
        }
    }
    
    func testTeamService()
    {
        let userService:UserService = UserService()
        
        //Login with correct credentials
        if userService.login(username: "koopaluigi", password: "toadstool") == ""
        {
            let user = userService.getUser()
            let teamService:TeamService = TeamService(auth_token: user.auth_token)
            
            //Add Team
            let team = teamService.addTeam(name: "Test Team", league_id: "0")
            XCTAssertFalse(team.id == -1)
            XCTAssertFalse(team.league_id == -1)
            XCTAssertFalse(team.name == "")
            XCTAssertFalse(team.date_created == "")
            XCTAssertTrue(team.name == "Test Team")
            XCTAssertTrue(team.league_id == 0)
        }
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
