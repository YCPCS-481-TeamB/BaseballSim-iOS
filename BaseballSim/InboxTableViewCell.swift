//
//  InboxTableViewCell.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/2/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell
{
    // MARK: Properties
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
