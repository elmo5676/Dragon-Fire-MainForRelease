//
//  RingTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/23/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class RingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @IBOutlet var ringNameLabel: UILabel!
    @IBOutlet var ringModelLabel: UILabel!
    @IBOutlet var ringClosedLabel: UILabel!
    @IBOutlet var ringFilledInLabel: UILabel!
    @IBOutlet var includedInBLLabel: UILabel!
    @IBOutlet var iconType: UIImageView!

}
