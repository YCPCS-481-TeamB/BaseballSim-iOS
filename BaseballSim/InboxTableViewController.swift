//
//  InboxTableViewController.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/7/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController
{
    var user:User = User(id: -1, first_name: "", last_name: "", username: "", email: "", date_created: "", auth_token: "", teams: [], games: [], approvals: [])
    var approvalService = ApprovalService(auth_token: "")
    var approvals:[Approval] = []
    var currentIndexPath:IndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(GamesTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)

        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                approvalService = ApprovalService(auth_token: user.auth_token)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //Update approvals
        approvals = approvalService.getApprovals()
        approvals.reverse()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return approvals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! InboxTableViewCell
                
        let approval = approvals[indexPath.row] as Approval
        cell.idLabel.text = String(approval.id)
        
        currentIndexPath = indexPath
        
        cell.acceptButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(InboxTableViewController.accept(_:)), for: .touchUpInside)
        cell.layer.borderWidth = 0.6;
        
        return cell
    }
    
    func accept(_ sender: UIButton!)
    {
        let approval_id = approvals[sender.tag].id
        approvalService.approve(id: String(approval_id))
        approvals.remove(at: sender.tag)
        tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
    func handleRefresh(refreshControl:UIRefreshControl)
    {
        //Update feed
        approvals = approvalService.getApprovals()
        approvals.reverse()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }


}
