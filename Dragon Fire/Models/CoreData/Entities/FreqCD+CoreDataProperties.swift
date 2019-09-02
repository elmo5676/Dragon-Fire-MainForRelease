//
//  FreqCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension FreqCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FreqCD> {
        return NSFetchRequest<FreqCD>(entityName: "FreqCD")
    }

    @NSManaged public var communicationsId_CD: Int32
    @NSManaged public var freq_CD: Double
    @NSManaged public var id_CD: Int32

}
