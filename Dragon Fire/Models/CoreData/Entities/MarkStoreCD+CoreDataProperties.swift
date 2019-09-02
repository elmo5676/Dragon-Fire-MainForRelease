//
//  MarkStoreCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension MarkStoreCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarkStoreCD> {
        return NSFetchRequest<MarkStoreCD>(entityName: "MarkStoreCD")
    }

    @NSManaged public var markBearingofPOItoBullsEye_CD: Double
    @NSManaged public var markBullseyeRefName_CD: String?
    @NSManaged public var markDistanceofPOItoBullsEye_CD: Double
    @NSManaged public var markMagVar_CD: Double
    @NSManaged public var markPilotAlt_CD: Double
    @NSManaged public var markPilotCoords_CD: [Double]?
    @NSManaged public var markPilotHeadingMag_CD: Double
    @NSManaged public var markPilotHeadingTrue_CD: Double
    @NSManaged public var markPOICoords_CD: String?
    @NSManaged public var markPOIMGRS_CD: String?
    @NSManaged public var markPOIUTM_CD: String?
    @NSManaged public var markTime_CD: NSDate?

}
