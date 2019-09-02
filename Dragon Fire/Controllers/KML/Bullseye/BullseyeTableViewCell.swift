//
//  BullseyeTableViewCell.swift
//  Dragon Fire
//
//  Created by elmo on 6/18/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData
import KML

class BullseyeTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
            setFormatting()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let cdu = CoreDataUtilities()
    @IBOutlet weak var nameOfBullseyeLabel: UILabel!
    @IBOutlet weak var centerPointLabel: UILabel!
    @IBOutlet weak var sizeOfBullsEyeLabel: UILabel!
    @IBOutlet weak var lineWidthLabel: UILabel!
    @IBOutlet weak var magVarLabel: UILabel!
    @IBOutlet weak var centerPointIncludedTextLabel: UILabel!
    @IBOutlet weak var centerPointIndicatorLabel: UILabel!
    @IBOutlet weak var rangelabelLabel: UILabel!
    @IBOutlet weak var rangeLabelIndicatorLabel: UILabel!
    @IBOutlet weak var bearingLabelIncludedTextLabel: UILabel!
    @IBOutlet weak var bearingLabelIndicatorLabel: UILabel!
    
    @IBOutlet weak var centerpointIconIncludedLabel: UILabel!
    @IBOutlet weak var centerpointIconIncludedIndicatorLabel: UILabel!
    @IBOutlet weak var rangeBearingIconIncludedLabel: UILabel!
    @IBOutlet weak var rangeBearingIconIncludedIndicatorLabel: UILabel!
    @IBOutlet weak var includedBEIndicatorLabel: UILabel!
    //Image Views - Icons
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var centerPointIcon: UIImageView!
    @IBOutlet weak var rangeBearingIcon: UIImageView!
    
    
    
    
    

    @IBOutlet weak var exportToForeFlightOutlet: UIButton!
    @IBAction func exportToForeFlight(_ sender: UIButton) {
            print(sender.tag)
    }
    
    func setFormatting() {
        let cornerRadius: CGFloat = 10
        centerPointIndicatorLabel.layer.cornerRadius = cornerRadius
        rangeLabelIndicatorLabel.layer.cornerRadius = cornerRadius
        bearingLabelIndicatorLabel.layer.cornerRadius = cornerRadius
        centerpointIconIncludedIndicatorLabel.layer.cornerRadius = cornerRadius
        rangeBearingIconIncludedIndicatorLabel.layer.cornerRadius = cornerRadius
        includedBEIndicatorLabel.layer.cornerRadius = cornerRadius
        colorImage.layer.cornerRadius = cornerRadius
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
