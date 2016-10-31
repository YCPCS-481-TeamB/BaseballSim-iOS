//
//  GamesTableViewCell.swift
//  BaseballSim
//
//  Created by Cooper Luetje on 10/13/16.
//  Copyright © 2016 TeamB. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell
{
    // Mark: Properties
    @IBOutlet weak var team1IdLabel: UILabel!
    @IBOutlet weak var team2IdLabel: UILabel!
    @IBOutlet weak var fieldIdLabel: UILabel!
    @IBOutlet weak var leagueIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
