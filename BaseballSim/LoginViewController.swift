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
    var url = "https://baseballsim-koopaluigi.c9users.io/api/users/token"   //Testing
    //var url = "https://baseballsim.herokuapp.com/api/players"         //Heroku
    var params: [String:AnyObject] = ["username":"koopaluigi" as AnyObject, "password":"toadstool" as AnyObject]
    var headers: [String:String] = ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJrb29wYWx1aWdpIiwicGFzc3dvcmQiOiIkMmEkMTAkeldlNFdVcG4vLi5yWTdpeU90YXliT0ZncGVkLjNJbG5IWVhtdHBBYTA1OUZmQXpmVUtBaWkiLCJmaXJzdG5hbWUiOiJDb29wZXIiLCJsYXN0bmFtZSI6Ikx1ZXRqZSIsImVtYWlsIjoia29vcGFsdWlnaUBob3RtYWlsLmNvbSIsImRhdGVfY3JlYXRlZCI6IjIwMTYtMTAtMDNUMTY6MTM6NDguMjgwWiIsImlhdCI6MTQ3NjE1NjMyNH0.va7_WXrC6B7ngIUl-cp4qqCus8C0GViKnsG_LMw2_Ss":"x-access-token"]
    var postHeaders: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = UserService()
        
        //service.getRequest(url: url, params: params, headers: headers)
        
        service.postRequest(url: url, params: params, headers: postHeaders)
        
        let p = UserDefaults.standard
        let key = "token"
        if p.object(forKey: key) == nil
        {
            
        }
        else
        {
            let value = p.string(forKey: key)
            errorLabel.text = value
        }
        
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
            errorLabel.text = service.getPostDictionary().value(forKey: "token") as! String?
            let p = UserDefaults.standard
            let key = "token"
            let value = service.getPostDictionary().value(forKey: "token")
            p.set(value, forKey: key)
            p.synchronize()
        }
    }

}

