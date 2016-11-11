//
//  GamesTableViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/13/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class GamesTableViewController: UITableViewController
{
    // MARK: Properties
    @IBOutlet weak var team1IdLabel: UILabel!
    @IBOutlet weak var team2IdLabel: UILabel!
    @IBOutlet weak var fieldIdLabel: UILabel!
    @IBOutlet weak var leagueIdLabel: UILabel!
    
    
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var gameService = GameService(auth_token: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    
    @IBAction func cancelAddGame(segue:UIStoryboardSegue)
    {
        
    }
    
    @IBAction func addGame(segue:UIStoryboardSegue)
    {
        
        if let addGameViewController = segue.source as? AddGameTableViewController
        {
            //Add new team to team array
            let team1_id = addGameViewController.team1_id
            let team2_id = addGameViewController.team2_id
            if(team1_id != "" && team2_id != "")
            {
                let game = gameService.addGame(team1_id: team1_id, team2_id: team2_id)
                
                if game.id != -1
                {
                    user.games.append(game)
                    
                    //Update View
                    let indexPath = IndexPath (row: user.games.count-1, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GamesTableViewCell
        
        let game = user.games[indexPath.row] as Game
        cell.team1IdLabel.text = String(game.team1_id)
        cell.team2IdLabel.text = String(game.team2_id)
        cell.fieldIdLabel.text = String(game.field_id)
        cell.leagueIdLabel.text = String(game.league_id)
        
        if(gameService.isGameApproved(game_id: game.id))
        {
            cell.backgroundColor = UIColor.green
        }
        else if(gameService.isGameDeclined(game_id: game.id))
        {
            cell.backgroundColor = UIColor.red
        }
        
        cell.layer.borderWidth = 0.6;

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Perform segue
    }

}
