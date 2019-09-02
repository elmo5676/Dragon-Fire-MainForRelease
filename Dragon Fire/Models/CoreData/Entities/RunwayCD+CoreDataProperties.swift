//
//  RunwayCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension RunwayCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunwayCD> {
        return NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
    }

    @NSManaged public var airfieldID_CD: Int32
    @NSManaged public var coordLatHi_CD: Double
    @NSManaged public var coordLatLow_CD: Double
    @NSManaged public var coordLonHi_CD: Double
    @NSManaged public var coordLonLow_CD: Double
    @NSManaged public var elevHi_CD: Double
    @NSManaged public var elevLow_CD: Double
    @NSManaged public var highID_CD: String?
    @NSManaged public var id_CD: Int32
    @NSManaged public var length_CD: Double
    @NSManaged public var lowID_CD: String?
    @NSManaged public var magHdgHi_CD: Double
    @NSManaged public var magHdgLow_CD: Double
    @NSManaged public var overrunHiLength_CD: Double
    @NSManaged public var overrunHiType_CD: String?
    @NSManaged public var overrunLowLength_CD: Double
    @NSManaged public var overrunLowType_CD: String?
    @NSManaged public var runwayCondition_CD: String?
    @NSManaged public var slopeHi_CD: Double
    @NSManaged public var slopeLow_CD: Double
    @NSManaged public var surfaceType_CD: String?
    @NSManaged public var tdzeHi_CD: Double
    @NSManaged public var tdzeLow_CD: Double
    @NSManaged public var trueHdgHi_CD: Double
    @NSManaged public var trueHdgLow_CD: Double
    @NSManaged public var width_CD: Double

}
