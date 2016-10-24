//
//  BaseballSimTests.swift
//  BaseballSimTests
//
//  Created by Cooper Luetje on 10/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import XCTest
@testable import BaseballSim

class BaseballSimTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginSucceed()
    {
        let userService:UserService = UserService()
        let succeed = userService.login(username: "koopaluigi", password: "toadstool")
        XCTAssertTrue(succeed == "")
    }
    
    func testLoginFailed()
    {
        let userService:UserService = UserService()
        
        //Username not entered
        var failure = userService.login(username: "", password: "")
        XCTAssertTrue(failure == "You must enter a username!")
        
        //Password not entered
        failure = userService.login(username: "koopaluigi", password: "")
        XCTAssertTrue(failure == "You must enter a password!")
        
        //Incorrect username/password combination
        failure = userService.login(username: "koopaluigi", password: "notit")
        XCTAssertTrue(failure == "The Password Is Invalid")
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
