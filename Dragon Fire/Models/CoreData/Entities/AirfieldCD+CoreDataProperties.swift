//
//  AirfieldCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension AirfieldCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirfieldCD> {
        return NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
    }

    @NSManaged public var communications_CD: [CommunicationCD]?
    @NSManaged public var country_CD: String?
    @NSManaged public var elevation_CD: Double
    @NSManaged public var faa_CD: String?
    @NSManaged public var icao_CD: String?
    @NSManaged public var id_CD: Int32
    @NSManaged public var latitude_CD: Double
    @NSManaged public var longitude_CD: Double
    @NSManaged public var mgrs_CD: String?
    @NSManaged public var name_CD: String?
    @NSManaged public var navaids_CD: [NavaidCD]?
    @NSManaged public var runways_CD: [RunwayCD]?
    @NSManaged public var state_CD: String?
    @NSManaged public var timeConversion_CD: String?

}
