//
//  PathTableViewCell.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/12/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit


class PathTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet var pathNameLabel: UILabel!
    @IBOutlet var pathModelLabel: UILabel!
    @IBOutlet var pathClosedLabel: UILabel!
    @IBOutlet var pathFilledInLabel: UILabel!
    @IBOutlet var includedInBLLabel: UILabel!
    
}
