//
//  ListOfDivertsTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 7/4/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class ListOfDivertsTableViewCell: UITableViewCell {

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
    @IBOutlet weak var ringSizeLabel: UILabel!
    @IBOutlet weak var icaoLabelIncludedLabel: UILabel!
    @IBOutlet weak var iconIncludedLabel: UILabel!
    @IBOutlet weak var ringIncludedLabel: UILabel!
    @IBOutlet weak var includedInBLLabel: UILabel!
    
    @IBOutlet weak var iconTypeImage: UIImageView!
    @IBOutlet weak var ringColorImage: UIImageView!
    
}
