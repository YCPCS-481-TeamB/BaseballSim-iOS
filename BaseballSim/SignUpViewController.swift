//
//  SignUpViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/28/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var userService = UserService()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButton(_ sender: UIButton)
    {
        userService.signUp(username: usernameTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!)
        
        
        //Go to the logged in views and save user to disk
        let defaults = UserDefaults.standard
        let key = "user"
        let value = userService.getUser()
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        
        defaults.setValue(encodedData, forKey: key)
        defaults.synchronize()
        
        performSegue(withIdentifier: "mainView", sender: self)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
    }

}
