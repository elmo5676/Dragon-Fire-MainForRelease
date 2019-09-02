//
//  PlaceMarkTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class PlaceMarkTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var placeMarksNameLabel: UILabel!
    @IBOutlet var coordslLabel: UILabel!
    @IBOutlet var iconIncludedlLabel: UILabel!
    @IBOutlet var nameLabelIncludedlLabel: UILabel!
    @IBOutlet var includedInBLLabel: UILabel!
    @IBOutlet var iconType: UIImageView!

}
