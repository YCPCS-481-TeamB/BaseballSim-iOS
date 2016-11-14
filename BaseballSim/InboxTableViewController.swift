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
    var visible:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        approvals = approvalService.getApprovals()
        
        
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GamesTableViewController.update), userInfo: nil, repeats: true)
        visible = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Update once then every 5 seconds with timer
        update()
        visible = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        visible = false
    }
    
    func update()
    {
        if visible
        {
            approvals = approvalService.getApprovals()
            self.tableView.reloadData()
        }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
