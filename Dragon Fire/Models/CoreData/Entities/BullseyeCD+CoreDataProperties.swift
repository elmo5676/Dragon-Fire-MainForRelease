//
//  BullseyeCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension BullseyeCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BullseyeCD> {
        return NSFetchRequest<BullseyeCD>(entityName: "BullseyeCD")
    }

    @NSManaged public var bearingIconsIncluded_CD: Bool
    @NSManaged public var bearingLabels_CD: Bool
    @NSManaged public var bullsEyeName_CD: String?
    @NSManaged public var centerPoint_CD: [Double]?
    @NSManaged public var centerpointIcon_CD: String?
    @NSManaged public var centerpointIconIncluded_CD: Bool
    @NSManaged public var centerpointLabel_CD: Bool
    @NSManaged public var includedInBL_CD: Bool
    @NSManaged public var itIsABullseye_CD: Bool
    @NSManaged public var lineColor_CD: String?
    @NSManaged public var lineOpacity_CD: String?
    @NSManaged public var lineThickness_CD: Int16
    @NSManaged public var magVariation_CD: Double
    @NSManaged public var polyColor_CD: String?
    @NSManaged public var polyOpacity_CD: String?
    @NSManaged public var radiusOfOuterRing_CD: Double
    @NSManaged public var rangeBearingIconType_CD: String?
    @NSManaged public var rangeIconsIncluded_CD: Bool
    @NSManaged public var rangeLabels_CD: Bool

}
