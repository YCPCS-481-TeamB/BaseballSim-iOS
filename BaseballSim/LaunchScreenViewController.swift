//
//  LaunchScreenViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/12/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController
{
    var service:UserService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = UserService()

        //If user is already logged in
        let defaults = UserDefaults.standard
        var key = "token"
        if defaults.object(forKey: key) != nil
        {
            let value = defaults.string(forKey: key)
            if(value != "")
            {
                key = "user"
                let userValue = service.getUser()
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: userValue)
                
                defaults.setValue(encodedData, forKey: key)
                defaults.synchronize()
                
                performSegue(withIdentifier: "loggedIn", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
