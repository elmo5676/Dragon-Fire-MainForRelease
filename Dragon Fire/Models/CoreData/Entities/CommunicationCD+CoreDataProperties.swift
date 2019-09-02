//
//  CommunicationCD+CoreDataProperties.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//

import Foundation
import CoreData


extension CommunicationCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommunicationCD> {
        return NSFetchRequest<CommunicationCD>(entityName: "CommunicationCD")
    }

    @NSManaged public var airfieldID_CD: Int32
    @NSManaged public var freqs_CD: [FreqCD]?
    @NSManaged public var id_CD: Int32
    @NSManaged public var name_CD: String?

}
