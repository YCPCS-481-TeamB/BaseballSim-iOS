//
//  PlayViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/9/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var base1Label: UILabel!
    @IBOutlet weak var base2Label: UILabel!
    @IBOutlet weak var base3Label: UILabel!
    @IBOutlet weak var ballsLabel: UILabel!
    @IBOutlet weak var strikesLabel: UILabel!
    @IBOutlet weak var outsLabel: UILabel!
    @IBOutlet weak var teamAtBatLabel: UILabel!
    @IBOutlet weak var inningLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var userService = UserService()
    var gameService = GameService(auth_token: "")
    var approvalService = ApprovalService(auth_token: "")
    var game = Game(id: -1, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
    var gameAction = GameAction(id: -1, game_id: -1, team_at_bat: -1, team1_score: -1, team2_score: -1, balls: -1, strikes: -1, outs: -1, inning: -1, type: "", message: "", date_created: "")
    var gameEvents:[GameAction] = []
    var gamePosition = GamePosition(id: -1, game_action_id: -1, onfirst_id: -1, onsecond_id: -1, onthird_id: -1, date_created: "")
    var user_teams:[Team] = []
    var approvals:[Approval] = []
    var at_bat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                gameService = GameService(auth_token: user.auth_token)
                approvalService = ApprovalService(auth_token: user.auth_token)
                user_teams = userService.getUserTeams(user_id: user.id)
            }
        }
        
        gameEvents = gameService.getEvents(game: game)
        //Set events in reverse order
        gameEvents.reverse()
        
        if(!gameEvents.isEmpty)
        {
            let lastAction = gameEvents[0]
            inningLabel.text = String(lastAction.inning)
            team1Label.text = String(lastAction.team1_score)
            team2Label.text = String(lastAction.team2_score)
            ballsLabel.text = String(lastAction.balls)
            strikesLabel.text = String(lastAction.strikes)
            outsLabel.text = String(lastAction.outs)
            teamAtBatLabel.text = "Team at Bat: \(lastAction.team_at_bat)"
        
            gamePosition = gameService.getLatestPosition(game: game)
            base1Label.text = String(gamePosition.onfirst_id)
            base2Label.text = String(gamePosition.onsecond_id)
            base3Label.text = String(gamePosition.onthird_id)
        }
        else
        {
            nextButton.isEnabled = false;
            let gameAlert = UIAlertController(title: "Select Game", message: "Please go to the games section and start or resume a game!", preferredStyle: UIAlertControllerStyle.alert)
            
            gameAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {  (action: UIAlertAction!) in
            }))
            
            present(gameAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextActionButton(_ sender: UIButton)
    {
        //Create next event
        gameService.nextEvent(game: game)
        gameAction = gameService.getLatestEvent(game: game)
        
        if gameAction.message == "Game Over!"
        {
            var message = ""
            if gameAction.team1_score > gameAction.team2_score
            {
                message = "Congratulations You Won!"
            }
            else if gameAction.team1_score < gameAction.team2_score
            {
                message = "You Lost! Better Luck Next Time!"
            }
            else
            {
                message = "You Tied!"
            }
            let gameAlert = UIAlertController(title: "Game Over", message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            gameAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {  (action: UIAlertAction!) in
            }))
            
            present(gameAlert, animated: true, completion: nil)
        }
        
        for team in user_teams
        {
            if team.id == gameAction.team_at_bat
            {
                at_bat = true
                approvals = approvalService.getApprovals()
                if !approvals.isEmpty
                {
                    let approval_id = String(approvals.first!.id)
                    approvalService.approve(id: approval_id)
                    
                    gameEvents.insert(gameAction, at: 0)
                    
                    inningLabel.text = String(gameAction.inning)
                    team1Label.text = String(gameAction.team1_score)
                    team2Label.text = String(gameAction.team2_score)
                    ballsLabel.text = String(gameAction.balls)
                    strikesLabel.text = String(gameAction.strikes)
                    outsLabel.text = String(gameAction.outs)
                    teamAtBatLabel.text = "Team at Bat: \(gameAction.team_at_bat)"
                    
                    gamePosition = gameService.getLatestPosition(game: game)
                    base1Label.text = String(gamePosition.onfirst_id)
                    base2Label.text = String(gamePosition.onsecond_id)
                    base3Label.text = String(gamePosition.onthird_id)
                    
                    //Update TableView
                    let indexPath = IndexPath (row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
                break
            }
            else
            {
                at_bat = false
            }
            
            if !at_bat
            {
                inningLabel.text = String(gameAction.inning)
                team1Label.text = String(gameAction.team1_score)
                team2Label.text = String(gameAction.team2_score)
                ballsLabel.text = "0"
                strikesLabel.text = "0"
                outsLabel.text = "0"
                teamAtBatLabel.text = "Team at Bat: \(gameAction.team_at_bat)"
                base1Label.text = "   -"
                base2Label.text = "   -"
                base3Label.text = "   -"
                
                let gameAlert = UIAlertController(title: "Other Teams Turn", message: "Wait for the other player to complete their inning!", preferredStyle: UIAlertControllerStyle.alert)
                
                gameAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {  (action: UIAlertAction!) in
                }))
                
                present(gameAlert, animated: true, completion: nil)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.gameEvents.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayCell", for: indexPath) as! GameActionTableViewCell
        
        let gameAction = self.gameEvents[indexPath.row]
        cell.messageLabel?.text = gameAction.message
        
        cell.layer.borderWidth = 0.6;
        cell.backgroundColor = UIColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.0)
        cell.messageLabel?.textColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("You selected cell #\(indexPath.row)!")
    }

}
