//
//  ViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var usersCollection = [User]()
    var service:UserService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = UserService()
        
        /*
        //If user is already logged in
        let p = UserDefaults.standard
        let key = "token"
        if p.object(forKey: key) != nil
        {
            let value = p.string(forKey: key)
            errorLabel.text = value
        }
        */
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: UIButton)
    {
        if usernameTextField.text == "" || passwordTextField.text == ""
        {
            errorLabel.text = "Please enter a correct username and password."
        }
        else
        {
            errorLabel.text = service.login(username: usernameTextField.text!, password: passwordTextField.text!)
            /*
            errorLabel.text = service.getPostDictionary().value(forKey: "token") as! String?
            let p = UserDefaults.standard
            let key = "user"
            let value = service.user
            p.set(value, forKey: key)
            p.synchronize()
            */
            
            //Go to logged in views
            
        }
    }

}

