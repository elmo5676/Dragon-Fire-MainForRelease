//
//  MarkStoreListTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/4/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class MarkStoreListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var fixNumberLabel: UILabel!
    @IBOutlet weak var markTimeLabel: UILabel!
    @IBOutlet weak var refBENameLabel: UILabel!
    @IBOutlet weak var markAltLabel: UILabel!
    @IBOutlet weak var coordsTakenLabel: UILabel!
    @IBOutlet weak var rangeToBELabel: UILabel!
    @IBOutlet weak var bearingToBELabel: UILabel!
    @IBOutlet weak var coordsOfPOILabel: UILabel!
    @IBOutlet weak var utmOfPOILabel: UILabel!
    @IBOutlet weak var mgrsOfLabel: UILabel!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet var stackViewCollection: [UIStackView]!
    @IBOutlet weak var fixImageView: UIImageView!
    
    
    
    
    
    
    
    
    
}
