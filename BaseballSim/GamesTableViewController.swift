//
//  GamesTableViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/13/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class GamesTableViewController: UITableViewController, UITabBarDelegate
{
    // MARK: Properties
    @IBOutlet weak var approvalTabBar: UITabBar!
    @IBOutlet weak var gamesIndicator: UIActivityIndicatorView!
    
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var team = Team(id: -1, league_id: -1, name: "", date_created: "")
    var userService = UserService()
    var gameService = GameService(auth_token: "")
    var teamService = TeamService(auth_token: "")
    var currentGame:Game = Game(id: -1, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
    var games:[Game] = []
    var approvedGames:[Game] = []
    var pendingGames:[Game] = []
    var teamsById:[Int:Team] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(GamesTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        self.refreshControl?.tintColor = UIColor.white
        
        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                gameService = GameService(auth_token: user.auth_token)
                teamService = TeamService(auth_token: user.auth_token)
            }
        }
        
        //Set tab bar items
        approvalTabBar.unselectedItemTintColor = UIColor.black
        approvalTabBar.selectedItem = approvalTabBar.items?[0]
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        // Show indicator
        gamesIndicator.isHidden = false
        
        // Update games
        games = userService.getUserGames(user_id: user.id)
        
        approvedGames = []
        pendingGames = []
        
        for game in games
        {
            team = teamService.getTeam(team_id: String(game.team1_id))
            if teamsById[game.team1_id] == nil
            {
                teamsById[game.team1_id] = team
            }
            team = teamService.getTeam(team_id: String(game.team2_id))
            if teamsById[game.team2_id] == nil
            {
                teamsById[game.team2_id] = team
            }
            if gameService.isGameApproved(game_id: game.id)
            {
                approvedGames.append(game)
            }
            else
            {
                pendingGames.append(game)
            }
        }
        if approvalTabBar.selectedItem == approvalTabBar.items?[0]
        {
            games = approvedGames
        }
        else
        {
            games = pendingGames
        }
        games.reverse()
        
        // Hide indicator
        gamesIndicator.isHidden = true
        
        self.tableView.reloadData()
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
                _ = gameService.addGame(team1_id: team1_id, team2_id: team2_id)
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
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GamesTableViewCell
        
        let game = games[indexPath.row] as Game
        let team1 = teamsById[game.team1_id]
        let team2 = teamsById[game.team2_id]
        cell.team1IdLabel.text = team1?.name
        cell.team2IdLabel.text = team2?.name
        cell.gameIdLabel.text = String(game.id)
        
        cell.layer.borderWidth = 0.6;
        cell.backgroundColor = UIColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.0)
        cell.team1IdLabel.textColor = UIColor.white
        cell.team2IdLabel.textColor = UIColor.white
        cell.gameIdLabel.textColor = UIColor.white

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let game = games[indexPath.row] as Game
        self.currentGame = game
        self.performSegue(withIdentifier: "currentGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "currentGame")
        {
            let navController = segue.destination as! UINavigationController
            let gameViewController = navController.viewControllers.first as! GameViewController
            gameViewController.game = currentGame
            gameViewController.gameService = gameService
        }
    }
    
    func handleRefresh(refreshControl:UIRefreshControl)
    {
        //Update feed
        games = userService.getUserGames(user_id: user.id)
        
        approvedGames = []
        pendingGames = []
        
        for game in games
        {
            team = teamService.getTeam(team_id: String(game.team1_id))
            if teamsById[game.team1_id] == nil
            {
                teamsById[game.team1_id] = team
            }
            team = teamService.getTeam(team_id: String(game.team2_id))
            if teamsById[game.team2_id] == nil
            {
                teamsById[game.team2_id] = team
            }
            if gameService.isGameApproved(game_id: game.id)
            {
                approvedGames.append(game)
            }
            else
            {
                pendingGames.append(game)
            }
        }
        if approvalTabBar.selectedItem == approvalTabBar.items?[0]
        {
            games = approvedGames
        }
        else
        {
            games = pendingGames
        }
        games.reverse()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        switch item.tag
        {
            case 1:
                games = approvedGames
                break
            
            case 2:
                games = pendingGames
                break
            
            default:
                break
        }
        games.reverse()
        self.tableView.reloadData()
    }

}
