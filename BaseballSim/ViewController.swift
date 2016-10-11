//
//  ViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: Properties
    var usersCollection = [User]()
    var service:UserService!
    var url = "https://baseballsim-koopaluigi.c9users.io/api/players"   //Testing
    //var url = "https://baseballsim.herokuapp.com/api/players"         //Heroku
    var params: [String:AnyObject] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = UserService()
        
        service.getRequest(url: url, params: params)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

