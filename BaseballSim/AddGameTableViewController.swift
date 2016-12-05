//
//  AddGameTableViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/30/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class AddGameTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    // MARK: Properties
    @IBOutlet weak var team1PickerView: UIPickerView!
    @IBOutlet weak var team2PickerView: UIPickerView!
    
    
    
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var game:Game = Game(id: -1, league_id: -1, field_id: -1, team1_id: -1, team2_id: -1, date_created: "")
    var userService = UserService()
    var teamService = TeamService(auth_token: "")
    var team1_data:[Team] = []
    var team2_data:[Team] = []
    var team1_id:String = ""
    var team2_id:String = ""
    var team1_name = ""
    var team2_name = ""
    var team1:Team = Team(id: -1, league_id: -1, name: "", date_created: "")
    var team2:Team = Team(id: -1, league_id: -1, name: "", date_created: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        team1PickerView.dataSource = self
        team1PickerView.delegate = self
        
        team2PickerView.dataSource = self
        team2PickerView.delegate = self

        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                teamService = TeamService(auth_token: user.auth_token)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        team1_data = userService.getUserTeams(user_id: user.id)
        team1 = team1_data[0]
        
        let tempData = teamService.getAllTeams()
        for team in tempData
        {
            var isUsersTeam = false
            for innerTeam in team1_data
            {
                if team.id == innerTeam.id
                {
                    isUsersTeam = true
                    break
                }
                else
                {
                    isUsersTeam = false
                }
            }
            if !isUsersTeam
            {
                team2_data.append(team)
            }
        }
        team2 = team2_data[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            team1PickerView.becomeFirstResponder()
        }
        if indexPath.section == 1
        {
            team2PickerView.becomeFirstResponder()
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //return data.count
        if pickerView.tag == 1
        {
            return team1_data.count
        }
        else
        {
            return team2_data.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        //return data[row]
        if pickerView.tag == 1
        {
            return team1_data[row].name
        }
        else
        {
            return team2_data[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1
        {
            team1 = team1_data[row]
        }
        else
        {
            team2 = team2_data[row]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Set variables for adding game
        team1_id = String(team1.id)
        team2_id = String(team2.id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
