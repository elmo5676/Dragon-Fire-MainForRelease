//
//  PlaceMarkCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension PlaceMarkCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceMarkCD> {
        return NSFetchRequest<PlaceMarkCD>(entityName: "PlaceMarkCD")
    }

    @NSManaged public var iconIncluded_CD: Bool
    @NSManaged public var iconType_CD: String?
    @NSManaged public var includedInBL_CD: Bool
    @NSManaged public var labelIncluded_CD: Bool
    @NSManaged public var latitude_CD: Double
    @NSManaged public var longitude_CD: Double
    @NSManaged public var name_CD: String?

}
