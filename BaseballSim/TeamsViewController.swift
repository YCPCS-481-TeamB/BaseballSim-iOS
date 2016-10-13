//
//  TeamsViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/12/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController
{
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [])

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                print("Loaded in Teams:")
                print(user.printVals())
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
