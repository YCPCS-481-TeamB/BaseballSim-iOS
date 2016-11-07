//
//  AddGameTableViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/30/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class AddGameTableViewController: UITableViewController
{
    // MARK: Properties
    @IBOutlet weak var team1TextField: UITextField!
    @IBOutlet weak var team2TextField: UITextField!
    
    
    
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var game:Game = Game(id: -1, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
    var team1_id:String = ""
    var team2_id:String = ""
    
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
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            team1TextField.becomeFirstResponder()
        }
        if indexPath.section == 1
        {
            team2TextField.becomeFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Set variables for adding game
        team1_id = team1TextField.text!
        team2_id = team2TextField.text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
