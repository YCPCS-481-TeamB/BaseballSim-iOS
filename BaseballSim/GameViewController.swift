//
//  GameViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/11/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
    var game:Game = Game(id: -1, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
    var gameService = GameService(auth_token: "")
    var gameEvents:[GameAction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Game \(game.id)"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        gameEvents = gameService.getEvents(game: game)
        if(!gameEvents.isEmpty)
        {
            startButton.setTitle("Resume Game", for: UIControlState.normal)
        }
    }
    
    @IBAction func startGameButton(_ sender: UIButton)
    {
        if(gameEvents.isEmpty && gameService.isGameApproved(game_id: game.id))
        {
            gameService.startGame(game: game)
            self.performSegue(withIdentifier: "startGame", sender: self)
        }
        else if(!gameService.isGameApproved(game_id: game.id))
        {
            let approvalAlert = UIAlertController(title: "Approval", message: "This game must be approved! Check your inbox!", preferredStyle: UIAlertControllerStyle.alert)
            
            approvalAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {  (action: UIAlertAction!) in
            }))
            
            present(approvalAlert, animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "startGame", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "startGame")
        {
            let tabController = segue.destination as! UITabBarController
            let navController = tabController.viewControllers?[2] as! UINavigationController
            let playViewController = navController.viewControllers.first as! PlayViewController
            playViewController.game = game
            playViewController.gameService = gameService
            
            tabController.selectedIndex = 2
        }
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
        
        cell.layer.borderWidth = 0.6;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("You selected cell #\(indexPath.row)!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
