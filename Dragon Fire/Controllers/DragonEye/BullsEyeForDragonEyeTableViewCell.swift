//
//  BullsEyeForDragonEyeTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/3/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class BullsEyeForDragonEyeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet var bullsEyeNameLabel: UILabel!
    @IBOutlet weak var coordsLabel: UILabel!
}
