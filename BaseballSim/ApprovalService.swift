//
//  ApprovalService.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/7/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import Foundation

class ApprovalService
{
    var apiRoutes:ApiRoutes
    var requests:Request
    var params:[String:String]!
    var headers:[String:String]!
    var error:String!
    var auth_token:String
    
    init(auth_token:String)
    {
        self.apiRoutes = ApiRoutes()
        self.requests = Request()
        self.params = [:]
        self.auth_token = auth_token
        self.headers = ["x-access-token":auth_token]
        self.error = ""
    }
    
    func getApprovals()
    {
        let request = DispatchGroup.init()
        
        let url = apiRoutes.approvals.getApprovals
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        // If approvals exist in the returned data from POST
        /*
        if (requests.postDictionary["approvals"]! as AnyObject).count != 0
        {
            let val = requests.postDictionary.value(forKey: "approvals")! as AnyObject
            print(val)
            /*
            let id = val.value(forKey: "id") as! Int
            let league_id = val.value(forKey: "league_id")! as! Int
            let field_id = val.value(forKey: "field_id")! as! Int
            let team1_id = val.value(forKey: "team1_id")! as! Int
            let team2_id = val.value(forKey: "team2_id")! as! Int
            let date_created = val.value(forKey: "date_created") as! String
            */
        }
        */
    }
}
