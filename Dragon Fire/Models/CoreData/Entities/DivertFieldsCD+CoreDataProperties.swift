//
//  DivertFieldsCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension DivertFieldsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DivertFieldsCD> {
        return NSFetchRequest<DivertFieldsCD>(entityName: "DivertFieldsCD")
    }

    @NSManaged public var iconIncluded_CD: Bool
    @NSManaged public var iconType_CD: String?
    @NSManaged public var includedInBL_CD: Bool
    @NSManaged public var latitude_CD: Double
    @NSManaged public var longitude_CD: Double
    @NSManaged public var name_CD: String?
    @NSManaged public var polyColor_CD: String?
    @NSManaged public var polyOpacity_CD: String?
    @NSManaged public var ringColor_CD: String?
    @NSManaged public var ringIncluded_CD: Bool
    @NSManaged public var ringSize_CD: Double
    @NSManaged public var icao_CD: String?
    @NSManaged public var icaoLabelIncluded_CD: Bool

}
