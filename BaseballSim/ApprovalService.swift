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
    
    func getApprovals() -> [Approval]
    {
        let request = DispatchGroup.init()
        
        let url = apiRoutes.approvals.getApprovals
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        var approvals:[Approval] = []
        
        // If approvals exist in the returned data from GET
        if (requests.getDictionary["approvals"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "approvals")! as AnyObject
            for i in 0...(val.count-1)
            {
                let innerVal = val[i]! as AnyObject
                let id = innerVal.value(forKey: "id") as! Int
                let approved = innerVal.value(forKey: "approved")! as! String
                let item_id = innerVal.value(forKey: "item_id")! as! Int
                let item_type = innerVal.value(forKey: "item_type")! as! String
                let date_created = innerVal.value(forKey: "date_created")! as! String
                
                let approval = Approval(id: id, approved: approved, item_id: item_id, item_type: item_type, date_created: date_created)
                approvals.append(approval)
            }
        }
        
        return approvals
    }
}
