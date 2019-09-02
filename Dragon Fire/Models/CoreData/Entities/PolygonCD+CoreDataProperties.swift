//
//  PolygonCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension PolygonCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PolygonCD> {
        return NSFetchRequest<PolygonCD>(entityName: "PolygonCD")
    }

    @NSManaged public var closed_CD: Bool
    @NSManaged public var coords_CD: [[Double]]?
    @NSManaged public var filledIn_CD: Bool
    @NSManaged public var includedInBL_CD: Bool
    @NSManaged public var lineColor_CD: String?
    @NSManaged public var lineOpacity_CD: String?
    @NSManaged public var name_CD: String?
    @NSManaged public var polyColor_CD: String?
    @NSManaged public var polyOpacity_CD: String?
    @NSManaged public var width_CD: Int16

}
