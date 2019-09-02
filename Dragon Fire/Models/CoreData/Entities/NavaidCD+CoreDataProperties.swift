//
//  NavaidCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension NavaidCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NavaidCD> {
        return NSFetchRequest<NavaidCD>(entityName: "NavaidCD")
    }

    @NSManaged public var airfieldID_CD: Int32
    @NSManaged public var channel_CD: Int32
    @NSManaged public var course_CD: Int32
    @NSManaged public var distance_CD: Double
    @NSManaged public var frequency_CD: Double
    @NSManaged public var id_CD: Int32
    @NSManaged public var ident_CD: String?
    @NSManaged public var lat_CD: Double
    @NSManaged public var long_CD: Double
    @NSManaged public var name_CD: String?
    @NSManaged public var tacanDMEMode_CD: String?
    @NSManaged public var type_CD: String?

}
