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
    
    
    var items: [String] = ["A", "B", "C"]
    
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var gameService = GameService(auth_token: "")
    var game = Game(id: 43, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
    var gameAction = GameAction(id: -1, game_id: -1, team_at_bat: -1, team1_score: -1, team2_score: -1, balls: -1, strikes: -1, outs: -1, inning: -1, type: "", message: "", date_created: "")
    var gameEvents:[GameAction] = []
    
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
            }
        }
        
        //gameService.getEvents(game: game)
    }
    
    @IBAction func nextActionButton(_ sender: UIButton)
    {
        gameAction = gameService.getLatestEvent(game: game)
        gameEvents.insert(gameAction, at: 0)
        
        //Update View
        let indexPath = IndexPath (row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.gameEvents.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let gameAction = self.gameEvents[indexPath.row]
        cell.textLabel?.text = gameAction.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("You selected cell #\(indexPath.row)!")
    }

}
