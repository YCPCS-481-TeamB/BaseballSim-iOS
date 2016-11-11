//
//  GameActionTableViewCell.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 11/10/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class GameActionTableViewCell: UITableViewCell
{
    // MARK: Properties
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
