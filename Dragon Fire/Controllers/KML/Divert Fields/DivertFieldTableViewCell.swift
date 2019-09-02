//
//  DivertFieldTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 7/3/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class DivertFieldTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var icaoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fieldElevLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var mgrsLabel: UILabel!
    @IBOutlet weak var timeConvLabel: UILabel!

}
