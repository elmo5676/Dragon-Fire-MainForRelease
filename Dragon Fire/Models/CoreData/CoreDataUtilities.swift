//
//  CoreDataUtilities.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 6/29/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataUtilities {
    
    
    // MARK: - Initial Load [General Handeling]
    func loadAirfieldsAndRunwaysToDBfromJSON(_ nameOfJSON: String, pc: NSPersistentContainer){
        pc.performBackgroundTask { (moc) in
            let airfieldstURL = Bundle.main.url(forResource: nameOfJSON, withExtension: "json")
            let decoder = JSONDecoder()
            var airfieldCounter = 0
            do {
                let resultAirfields = try decoder.decode(Airfields.self, from: Data(contentsOf: airfieldstURL!))
                _ = resultAirfields.map { (airfield) -> AirfieldCD in
                    let airfieldDB = AirfieldCD(context: moc)
                    airfieldDB.country_CD = airfield.country
                    airfieldDB.elevation_CD = airfield.elevation
                    airfieldDB.faa_CD = airfield.faa
                    airfieldDB.icao_CD = airfield.icao
                    airfieldDB.id_CD = Int32(airfield.id)
                    airfieldDB.latitude_CD = airfield.lat
                    airfieldDB.longitude_CD = airfield.lon
                    airfieldDB.mgrs_CD = airfield.mgrs
                    airfieldDB.name_CD = airfield.name
                    airfieldDB.state_CD = airfield.state
                    airfieldDB.timeConversion_CD = airfield.timeConversion
                    
                    for runway in airfield.runways {
                        let runwayDB = RunwayCD(context: moc)
                        runwayDB.airfieldID_CD = airfieldDB.id_CD
                        runwayDB.id_CD = Int32(runway.id)
                        runwayDB.lowID_CD = runway.lowID
                        runwayDB.highID_CD = runway.highID
                        runwayDB.length_CD = runway.length
                        runwayDB.width_CD = runway.width
                        runwayDB.surfaceType_CD = runway.surfaceType
                        runwayDB.runwayCondition_CD = runway.runwayCondition
                        runwayDB.magHdgHi_CD = runway.magHdgHi
                        runwayDB.magHdgLow_CD = runway.magHdgLow
                        runwayDB.trueHdgHi_CD = runway.trueHdgHi
                        runwayDB.trueHdgLow_CD = runway.trueHdgLow
                        runwayDB.coordLatHi_CD = runway.coordLatHi
                        runwayDB.coordLatLow_CD = runway.coordLatLo
                        runwayDB.coordLonHi_CD = runway.coordLonHi
                        runwayDB.coordLonLow_CD = runway.coordLonLo
                        runwayDB.elevHi_CD = runway.elevHi
                        runwayDB.elevLow_CD = runway.elevLow
                        runwayDB.slopeHi_CD = runway.slopeHi
                        runwayDB.slopeLow_CD = runway.slopeLow
                        runwayDB.tdzeHi_CD = runway.tdzeHi
                        runwayDB.tdzeLow_CD = runway.tdzeLow
                        runwayDB.overrunHiLength_CD = runway.overrunHiLength
                        runwayDB.overrunLowLength_CD = runway.overrunLowLength
                        runwayDB.overrunHiType_CD = runway.overrunHiType
                        runwayDB.overrunLowType_CD = runway.overrunLowType
                    }
                    for navaid in airfield.navaids {
                        let navaidDB = NavaidCD(context: moc)
                        navaidDB.airfieldID_CD = airfieldDB.id_CD
                        navaidDB.id_CD = Int32(navaid.id)
                        navaidDB.name_CD = navaid.name
                        navaidDB.ident_CD = navaid.ident
                        navaidDB.type_CD = navaid.type
                        navaidDB.lat_CD = navaid.lat
                        navaidDB.long_CD = navaid.lon
                        navaidDB.frequency_CD = navaid.frequency
                        navaidDB.channel_CD = Int32(navaid.channel)
                        navaidDB.tacanDMEMode_CD = navaid.tacanDMEMode
                        navaidDB.course_CD = Int32(navaid.course)
                        navaidDB.distance_CD = navaid.distance
                    }
                    for comm in airfield.communications {
                        let communicationDB = CommunicationCD(context: moc)
                        communicationDB.airfieldID_CD = airfieldDB.id_CD
                        communicationDB.id_CD = Int32(comm.id)
                        communicationDB.name_CD = comm.name
                        for freq in comm.freqs {
                            let freqDB = FreqCD(context: moc)
                            freqDB.communicationsId_CD = communicationDB.id_CD
                            freqDB.id_CD = Int32(freq.id)
                            freqDB.freq_CD = freq.freq
                        }}
                    airfieldCounter += 1
                    return airfieldDB
                }
                moc.performAndWait {
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            } catch {print(error)}
        }
    }
    
    func printResults(pc: NSPersistentContainer) -> (numOfAirfields: Int, numOfRunways: Int, numOfNavaids: Int, numOfComms: Int) {
        
        var numOfAirfields = 0
        var numOfRunways = 0
        var numOfNavaids = 0
        var numOfComms = 0
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        pc.performBackgroundTask { (moc) in
            do {
                let runwayRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RunwayCD")
                let runwayCount = try moc.count(for: runwayRequest)
                numOfRunways = runwayCount
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
            do {
                let navRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NavaidCD")
                let navCount = try moc.count(for: navRequest)
                numOfNavaids = navCount
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
            do {
                let comRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommunicationCD")
                let comCount = try moc.count(for: comRequest)
                numOfComms = comCount
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
            do {
                let airportValidationRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AirfieldCD")
                let airportCount = try moc.count(for: airportValidationRequest)
                numOfAirfields = airportCount
            }   catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
            dispatchGroup.leave()
        }
        dispatchGroup.wait()
        print("Number of Airfields: \(numOfAirfields)")
        print("Number of Runways: \(numOfRunways)")
        print("Number of Navaids: \(numOfNavaids)")
        print("Number of Freqs: \(numOfComms)")
        return (numOfAirfields: numOfAirfields, numOfRunways: numOfRunways, numOfNavaids: numOfNavaids, numOfComms: numOfComms)
    }
    
    
    func verifyCoreDataMatchesJSON(nameOfJSON: String, pc: NSPersistentContainer) {
        pc.performBackgroundTask({ context in
            let startTime = Date()
            var airfieldReturn = false
            var runwayReturn = false
            var navaidReturn = false
            var commReturn = false
            var counterAirfieldsJSON = 0
            var counterRunwaysJSON = 0
            var counterNavaidsJSON = 0
            var counterCommsJSON = 0
            let counterAirfieldsCD = self.printResults(pc: pc).numOfAirfields
            let counterRunwaysCD = self.printResults(pc: pc).numOfRunways
            let counterNavaidsCD = self.printResults(pc: pc).numOfNavaids
            let counterCommsCD = self.printResults(pc: pc).numOfComms
            let documentsURL = Bundle.main.url(forResource: nameOfJSON, withExtension: "json")
            let decoder = JSONDecoder()
            do {
                let resultAirfields = try decoder.decode(Airfields.self, from: Data(contentsOf: documentsURL!))
                counterAirfieldsJSON += resultAirfields.count
                for airfield in resultAirfields {
                    counterRunwaysJSON += airfield.runways.count
                    counterNavaidsJSON += airfield.navaids.count
                    counterCommsJSON += airfield.communications.count
                }
            } catch {print(error)}
            if counterAirfieldsCD == counterAirfieldsJSON {
                airfieldReturn = true
            }
            if counterRunwaysCD == counterRunwaysJSON {
                runwayReturn = true
            }
            if counterNavaidsCD == counterNavaidsJSON {
                navaidReturn = true
            }
            if counterCommsCD == counterCommsJSON {
                commReturn = true
            }
            print("*****************************************************************************")
            print("Airfields in JSON: \(counterAirfieldsJSON)")
            print("Airfields in CoreData: \(counterAirfieldsCD)")
            print("*****************************************************************************")
            print("Runways in JSON: \(counterRunwaysJSON)")
            print("Runways in CoreData: \(counterRunwaysCD)")
            print("*****************************************************************************")
            print("Navaids in JSON: \(counterNavaidsJSON)")
            print("Navaids in CoreData: \(counterNavaidsCD)")
            print("*****************************************************************************")
            print("Comms in JSON: \(counterCommsJSON)")
            print("Comms in CoreData: \(counterCommsCD)")
            print("*****************************************************************************")
            let endTime = Date()
            print("Airfields match: \(airfieldReturn)")
            print("Runways match: \(runwayReturn)")
            print("Navaids match: \(navaidReturn)")
            print("Comms match: \(commReturn)")
            print("*****************************************************************************")
            print("Completion Time: \(endTime.timeIntervalSince(startTime))")
            print("*****************************************************************************")
            
            
            if airfieldReturn == false || counterAirfieldsCD == 0  || counterAirfieldsCD > counterAirfieldsJSON || runwayReturn == false || counterRunwaysCD == 0 || counterRunwaysCD > counterRunwaysJSON {
                self.deleteAllAirfieldsFromDB(pc: pc)
                var counter = 1
                let start = Date()
                self.loadAirfieldsAndRunwaysToDBfromJSON(nameOfJSON, pc: pc)
                DispatchQueue.main.async {
                    _ = self.printResults(pc: pc)
                    print(counter)
                    counter += 1
                    let end = Date()
                    print("Completion Time: \(end.timeIntervalSince(start))")
                }
            } else {
                print("Airfield and Runway JSON has previously, succesfully been loaded into CoreData")
            }
            DispatchQueue.main.async {
                print("Done")
            }
        })
    }
    
    // MARK: - Airfield and Runway
    let runwayLengthDefaultForNow = 2000
    func getRunwaysGreaterThanOrEqualToUserSettingsMinRWYLength(moc: NSManagedObjectContext) -> [RunwayCD] {
        let runwayLength = runwayLengthDefaultForNow
        var runways = [RunwayCD]()
        let runwayLengthFetchRequest = NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
        let runwayLengthPredicate: NSPredicate = {
            return NSPredicate(format: "%K => %@", #keyPath(RunwayCD.length_CD), "\(runwayLength)")
        }()
        runwayLengthFetchRequest.predicate = runwayLengthPredicate
        do {
            runways = try moc.fetch(runwayLengthFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return runways
    }
    
    func getAirfieldsWith(airfieldID id: Int32, moc: NSManagedObjectContext) -> [AirfieldCD] {
        var airfields = [AirfieldCD]()
        let airfieldFetchRequest = NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
        let airfieldPredicate: NSPredicate = {
            return NSPredicate(format: "%K = %@", #keyPath(AirfieldCD.id_CD),"\(id)")
        }()
        airfieldFetchRequest.predicate = airfieldPredicate
        do {
            airfields = try moc.fetch(airfieldFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return airfields
    }
    
    func getRunwaysAtAirfieldWithRWYLengthGreaterThanOrEqualToUserSettingsMinRWYLength(airfieldId: Int32 , moc: NSManagedObjectContext) -> [RunwayCD] {
        let runwayLength = runwayLengthDefaultForNow
        var runways = [RunwayCD]()
        let runwayFetchRequest = NSFetchRequest<RunwayCD>(entityName: "RunwayCD")
        let lengthPredicate: NSPredicate = {
            return NSPredicate(format: "%K => %@", #keyPath(RunwayCD.length_CD), "\(runwayLength)")
        }()
        let airfieldIdPredicate: NSPredicate = {
            return NSPredicate(format: "%K = %@", #keyPath(RunwayCD.airfieldID_CD), "\(airfieldId)")
        }()
        let groupedPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [lengthPredicate, airfieldIdPredicate])
        runwayFetchRequest.predicate = groupedPredicate
        do {
            runways = try moc.fetch(runwayFetchRequest)
        } catch let error as NSError {
            print("Could not fetch the Runways: \(error) : \(error.userInfo)")
        }
        return runways
    }
    
    func getAirfieldAndRunwaysWithRWYLengthGreaterThanOrEqualToUserSettingsMinRWYLength(moc: NSManagedObjectContext) -> [AirfieldCD:[RunwayCD]] {
        var resultsDict = [AirfieldCD:[RunwayCD]]()
        var airfields = [AirfieldCD]()
        var runwaysIntermediate = [RunwayCD]()
        var airfieldIDSet = Set<Int32>()
        //Step - 1: Get Runways with a length of: length
        runwaysIntermediate = getRunwaysGreaterThanOrEqualToUserSettingsMinRWYLength(moc: moc)
        //Step - 2: Get Set of Airfield IDs from: Step - 1
        for runway in runwaysIntermediate {
            airfieldIDSet.insert(runway.airfieldID_CD)
        }
        //Step - 3: Get Airfields with ID of: airfieldIDSet
        for id in airfieldIDSet {
            var afs = [AirfieldCD]()
            afs = getAirfieldsWith(airfieldID: id, moc: moc)
            for af in afs {
                airfields.append(af)
            }
        }
        //Step - 4: Set dictionary with Airfield and Runways
        for airfield in airfields {
            var runways = [RunwayCD]()
            runways = getRunwaysAtAirfieldWithRWYLengthGreaterThanOrEqualToUserSettingsMinRWYLength(airfieldId: airfield.id_CD, moc: moc)
            resultsDict[airfield] = runways
        }
        return resultsDict
    }
    
    func getAirfieldWithRWYLengthGreaterThanOrEqualToUserSettingsMinRWYLength(moc: NSManagedObjectContext) -> [AirfieldCD] {
        var airfields = [AirfieldCD]()
        var runwaysIntermediate = [RunwayCD]()
        var airfieldIDSet = Set<Int32>()

        //Step - 1: Get Runways with a length of: length
        runwaysIntermediate = getRunwaysGreaterThanOrEqualToUserSettingsMinRWYLength(moc: moc)

        //Step - 2: Get Set of Airfield IDs from: Step - 1
        for runway in runwaysIntermediate {
            airfieldIDSet.insert(runway.airfieldID_CD)
        }

        //Step - 3: Get Airfields with ID of: airfieldIDSet
        for id in airfieldIDSet {
            var afs = [AirfieldCD]()
            afs = getAirfieldsWith(airfieldID: id, moc: moc)
            for af in afs {
                airfields.append(af)
            }
        }

        return airfields
    }
    
    func getAirfieldByICAO_(_ icao: String, pc: NSPersistentContainer)  -> [AirfieldCD] {
        let moc = pc.viewContext
        var airfields = [AirfieldCD]()
        let airfieldFetchRequest = NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
        let airfieldFetchRequest_ = NSFetchRequest<AirfieldCD>(entityName: "AirfieldCD")
        let airfieldPredicate: NSPredicate = {
            return NSPredicate(format: "%K = %@", #keyPath(AirfieldCD.icao_CD),"\(icao)")
        }()
        airfieldFetchRequest.predicate = airfieldPredicate
        do {
            airfields = try moc.fetch(airfieldFetchRequest)
            _ = try moc.fetch(airfieldFetchRequest_).filter({ $0.icao_CD != "" })
        } catch {
            print(error)
        }
        return airfields
    }
    
    func deleteAllAirfieldsFromDB(pc: NSPersistentContainer, dg: DispatchGroup) {
        pc.performBackgroundTask { (moc) in
            let deleteAirPort = NSBatchDeleteRequest(fetchRequest: AirfieldCD.fetchRequest())
            let deleteRunway = NSBatchDeleteRequest(fetchRequest: RunwayCD.fetchRequest())
            let deleteNavaids = NSBatchDeleteRequest(fetchRequest: NavaidCD.fetchRequest())
            let deleteFreqs = NSBatchDeleteRequest(fetchRequest: CommunicationCD.fetchRequest())
            do {
                try moc.execute(deleteAirPort)
                try moc.execute(deleteRunway)
                try moc.execute(deleteNavaids)
                try moc.execute(deleteFreqs)
                try moc.save()
            } catch {
                print("Nope")
            }
            dg.leave()
        }}
    
    func deleteAllAirfieldsFromDB(pc: NSPersistentContainer) {
        pc.performBackgroundTask { (moc) in
            let deleteAirPort = NSBatchDeleteRequest(fetchRequest: AirfieldCD.fetchRequest())
            let deleteRunway = NSBatchDeleteRequest(fetchRequest: RunwayCD.fetchRequest())
            let deleteNavaids = NSBatchDeleteRequest(fetchRequest: NavaidCD.fetchRequest())
            let deleteFreqs = NSBatchDeleteRequest(fetchRequest: CommunicationCD.fetchRequest())
            do {
                try moc.execute(deleteAirPort)
                try moc.execute(deleteRunway)
                try moc.execute(deleteNavaids)
                try moc.execute(deleteFreqs)
                try moc.save()
            } catch {
                print("Nope")
            }}}
    
    func deleteAirfieldsFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deleteAirPort = NSBatchDeleteRequest(fetchRequest: AirfieldCD.fetchRequest())
        do {
            try moc.execute(deleteAirPort)
            try moc.save()
            print("All Airfields were succesfully deleted from CoreData")
        } catch {
            print("Nope")
        }
    }
    
    func deleteRunwaysFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deleteRunway = NSBatchDeleteRequest(fetchRequest: RunwayCD.fetchRequest())
        do {
            try moc.execute(deleteRunway)
            try moc.save()
            print("All Runways were succesfully deleted from CoreData")
        } catch {
            print("Nope")
        }
    }

    // MARK: - Naviad
    func getNavaids(moc: NSManagedObjectContext) -> [NavaidCD] {
        var navaids = [NavaidCD]()
        let navaidFetchRequest = NSFetchRequest<NavaidCD>(entityName: "NavaidCD")
        do {
            navaids = try moc.fetch(navaidFetchRequest)
        } catch {
            print(error)
        }
        return navaids
    }
    
    func deleteNavaidsFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deleteNavaids = NSBatchDeleteRequest(fetchRequest: NavaidCD.fetchRequest())
        do {
            try moc.execute(deleteNavaids)
            try moc.save()
            print("All Navaids were succesfully deleted from CoreData")
        } catch {
            print("Nope")
        }}
    
    // MARK: - Communication
    func getFreqs(pc: NSPersistentContainer) -> [FreqCD] {
        let moc: NSManagedObjectContext = pc.viewContext
        var freqs = [FreqCD]()
        let freqFetchRequest = NSFetchRequest<FreqCD>(entityName: "FreqCD")
        do {
            freqs = try moc.fetch(freqFetchRequest)
        } catch {
            print(error)
        }
        return freqs
    }
    
    func deleteCommsFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deleteFreqs = NSBatchDeleteRequest(fetchRequest: CommunicationCD.fetchRequest())
        do {
            try moc.execute(deleteFreqs)
            try moc.save()
            print("All Communications were succesfully deleted from CoreData")
        } catch {
            print("Nope")
        }}

    // MARK: - Bullseye
    func setBullseye(bearingIconsIncluded: Bool,
                     bearingLabels: Bool,
                     bullsEyeName: String,
                     centerPoint: [Double],
                     centerpointIcon: String,
                     centerpointIconIncluded: Bool,
                     centerpointLabel: Bool,
                     lineColor: String,
                     lineOpacity: String,
                     lineThickness: Int16,
                     magVariation: Double,
                     polyColor: String,
                     polyOpacity: String,
                     radiusOfOuterRing: Double,
                     rangeBearingIconType: String,
                     rangeIconsIncluded: Bool,
                     rangeLabels: Bool,
                     includedInBL: Bool,
                     itIsABullseye: Bool,
                     pc: NSPersistentContainer) {
        let context = pc.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BullseyeCD", in: context)
        let newBullseye = NSManagedObject(entity: entity!, insertInto: context)
        newBullseye.setValue(bearingIconsIncluded, forKey: "bearingIconsIncluded_CD")
        newBullseye.setValue(bearingLabels, forKey: "bearingLabels_CD")
        newBullseye.setValue(bullsEyeName, forKey: "bullsEyeName_CD")
        newBullseye.setValue(centerPoint, forKey: "centerPoint_CD")
        newBullseye.setValue(centerpointIcon, forKey: "centerpointIcon_CD")
        newBullseye.setValue(centerpointIconIncluded, forKey: "centerpointIconIncluded_CD")
        newBullseye.setValue(centerpointLabel, forKey: "centerpointLabel_CD")
        newBullseye.setValue(lineColor, forKey: "lineColor_CD")
        newBullseye.setValue(lineOpacity, forKey: "lineOpacity_CD")
        newBullseye.setValue(lineThickness, forKey: "lineThickness_CD")
        newBullseye.setValue(magVariation, forKey: "magVariation_CD")
        newBullseye.setValue(polyColor, forKey: "polyColor_CD")
        newBullseye.setValue(polyOpacity, forKey: "polyOpacity_CD")
        newBullseye.setValue(radiusOfOuterRing, forKey: "radiusOfOuterRing_CD")
        newBullseye.setValue(rangeBearingIconType, forKey: "rangeBearingIconType_CD")
        newBullseye.setValue(rangeIconsIncluded, forKey: "rangeIconsIncluded_CD")
        newBullseye.setValue(rangeLabels, forKey: "rangeLabels_CD")
        newBullseye.setValue(includedInBL, forKey: "includedInBL_CD")
        newBullseye.setValue(itIsABullseye, forKey: "itIsABullseye_CD")
        do {
            try context.save()
        } catch {
            print("Bullseye failed to save")
        }}
    
    func getBullseye(pc: NSPersistentContainer) -> [BullseyeCD] {
        var result: [BullseyeCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "itIsABullseye_CD == %@", NSNumber(value: true))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BullseyeCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [BullseyeCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func getBullseyeNamed(_ name: String, pc: NSPersistentContainer) -> [BullseyeCD] {
        var result: [BullseyeCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BullseyeCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [BullseyeCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func getBullseyeIncludedInBL(_ included: Bool, pc: NSPersistentContainer) -> [BullseyeCD] {
        var result: [BullseyeCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "includedInBL_CD == %@", NSNumber(value: included))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BullseyeCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [BullseyeCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    //SARDOT
    func getSarDot(pc: NSPersistentContainer) -> [BullseyeCD] {
        var result: [BullseyeCD] = []
        let context = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BullseyeCD")
        let predicate = NSPredicate(format: "itIsABullseye_CD == %@", NSNumber(value: false))
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [BullseyeCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func deleteBullseyeNamed(_ name: String, pc: NSPersistentContainer){
        var result: [BullseyeCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BullseyeCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [BullseyeCD]
            for r in result {
                pc.viewContext.delete(r)
            }
        } catch {
            print("Failed to retrieve bullseye")
        }}
    
    func deleteAllBEandSARDOTFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deleteAll = NSFetchRequest<NSFetchRequestResult>(entityName: "BullseyeCD")
        let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteAll)
        batchDelete.resultType = .resultTypeCount
        do {
            let batchDeleteResult = try moc.execute(batchDelete) as! NSBatchDeleteResult
            print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
            moc.reset()
        } catch {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }}
    
    // MARK: - Divert Fields
    func addDivertField(icao: String,
                        includedInBL: Bool,
                        latitude: Double,
                        longitude: Double,
                        name: String,
                        ringColor: String,
                        ringSize: Double,
                        iconType: String,
                        iconIncluded: Bool,
                        ringIncluded: Bool,
                        icaoLabelIncluded: Bool,
                        pc: NSPersistentContainer) {
        let context = pc.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DivertFieldsCD", in: context)
        let newDivertField = NSManagedObject(entity: entity!, insertInto: context)
        newDivertField.setValue(icao, forKey: "icao_CD")
        newDivertField.setValue(includedInBL, forKey: "includedInBL_CD")
        newDivertField.setValue(latitude, forKey: "latitude_CD")
        newDivertField.setValue(longitude, forKey: "longitude_CD")
        newDivertField.setValue(name, forKey: "name_CD")
        newDivertField.setValue(ringColor, forKey: "ringColor_CD")
        newDivertField.setValue(ringSize, forKey: "ringSize_CD")
        newDivertField.setValue(iconType, forKey: "iconType_CD")
        newDivertField.setValue(iconIncluded, forKey: "iconIncluded_CD")
        newDivertField.setValue(ringIncluded, forKey: "ringIncluded_CD")
        newDivertField.setValue(icaoLabelIncluded, forKey: "icaoLabelIncluded_CD")
        do {
            try context.save()
        } catch {
            print("Divert failed to save")
        }}
    
    func getDivertFields(pc: NSPersistentContainer) -> [DivertFieldsCD] {
        var result: [DivertFieldsCD] = []
        let context = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DivertFieldsCD")
        do {
            result = try context.fetch(request) as! [DivertFieldsCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func deleteAllDivertsFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deleteAirPort = NSBatchDeleteRequest(fetchRequest: DivertFieldsCD.fetchRequest())
        do {
            try moc.execute(deleteAirPort)
            try moc.save()
        } catch {
            print("Nope")
        }}
    
    func deleteAllDivertsFromDB_(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DivertFieldsCD")
        let deleteAll = NSBatchDeleteRequest(fetchRequest: request)
        do { try moc.execute(deleteAll) }
             catch { print(error) }}
    
    func deleteDivertwithIcao(_ icao: String, pc: NSPersistentContainer){
        var result: [DivertFieldsCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "icao_CD == %@", icao)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DivertFieldsCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [DivertFieldsCD]
            for r in result { pc.viewContext.delete(r) }
            try context.save()
        } catch {
            print("Failed to retrieve bullseye")
        }}
    
    func getDivertFieldsIncludedInBL(_ included: Bool, pc: NSPersistentContainer) -> [DivertFieldsCD] {
        var result: [DivertFieldsCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "includedInBL_CD == %@", NSNumber(value: included))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DivertFieldsCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [DivertFieldsCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    // MARK: - Polygons/Paths
    func addPolygon(closed: Bool,
                    coords: [[Double]],
                    filledIn: Bool,
                    includedInBL: Bool,
                    lineColor: String,
                    lineOpacity: String,
                    name: String,
                    polyColor: String,
                    polyOpacity: String,
                    width: Int,
                    pc: NSPersistentContainer) {
        let context = pc.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PolygonCD", in: context)
        let newPolygon = NSManagedObject(entity: entity!, insertInto: context)
        newPolygon.setValue(closed, forKey: "closed_CD")
        newPolygon.setValue(coords, forKey: "coords_CD")
        newPolygon.setValue(filledIn, forKey: "filledIn_CD")
        newPolygon.setValue(includedInBL, forKey: "includedInBL_CD")
        newPolygon.setValue(lineColor, forKey: "lineColor_CD")
        newPolygon.setValue(lineOpacity, forKey: "lineOpacity_CD")
        newPolygon.setValue(name, forKey: "name_CD")
        newPolygon.setValue(polyColor, forKey: "polyColor_CD")
        newPolygon.setValue(polyOpacity, forKey: "polyOpacity_CD")
        newPolygon.setValue(width, forKey: "width_CD")
        do {
            try context.save()
        } catch {
            print("MarkStore failed to save")
        }}
    
    func getPolygon(pc: NSPersistentContainer) -> [PolygonCD] {
        var result: [PolygonCD] = []
        let context = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PolygonCD")
        do {
            result = try context.fetch(request) as! [PolygonCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
    func getPolygonNamed(_ name: String, pc: NSPersistentContainer) -> [PolygonCD] {
        var result: [PolygonCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PolygonCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [PolygonCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    func getPolygonsIncludedInBL(_ included: Bool, pc: NSPersistentContainer) -> [PolygonCD] {
        var result: [PolygonCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "includedInBL_CD == %@", NSNumber(value: included))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PolygonCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [PolygonCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func deleteAllPolygonsFromDB(pc: NSPersistentContainer) {
        let moc = pc.viewContext
        let deletePolygon = NSBatchDeleteRequest(fetchRequest: PolygonCD.fetchRequest())
        do {
            try moc.execute(deletePolygon)
            try moc.save()
        } catch {
            print("Nope")
        }}
    
    
    func deleteAllPolyonsFromDB(pc: NSPersistentContainer) {
        pc.performBackgroundTask { (moc) in
            let deletePolygons = NSBatchDeleteRequest(fetchRequest: PolygonCD.fetchRequest())
            do {
                try moc.execute(deletePolygons)
                try moc.save()
            } catch {
                print("Nope")
            }}}
    
    func deletePolygonNamed(_ name: String, pc: NSPersistentContainer){
        var result: [PolygonCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PolygonCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [PolygonCD]
            for r in result {
                pc.viewContext.delete(r)
            }
        } catch {
            print("Failed to retrieve bullseye")
        }}
    
    // MARK: - Rings
    func addRing(ringSize: Double,
                 ringIncluded: Bool,
                 ringColor: String,
                 polyOpacity: String,
                 polyColor: String,
                 name: String,
                 longitude: Double,
                 latitude: Double,
                 includedInBL_CD: Bool,
                 iconType: String,
                 iconIncluded: Bool,
                 width: Int,
                 pc: NSPersistentContainer) {
        let context = pc.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RingCD", in: context)
        let newRing = NSManagedObject(entity: entity!, insertInto: context)
        newRing.setValue(ringSize, forKey: "ringSize_CD")
        newRing.setValue(ringIncluded, forKey: "ringIncluded_CD")
        newRing.setValue(ringColor, forKey: "ringColor_CD")
        newRing.setValue(polyOpacity, forKey: "polyOpacity_CD")
        newRing.setValue(polyColor, forKey: "polyColor_CD")
        newRing.setValue(name, forKey: "name_CD")
        newRing.setValue(longitude, forKey: "longitude_CD")
        newRing.setValue(latitude, forKey: "latitude_CD")
        newRing.setValue(includedInBL_CD, forKey: "includedInBL_CD")
        newRing.setValue(iconType, forKey: "iconType_CD")
        newRing.setValue(iconIncluded, forKey: "iconIncluded_CD")
        newRing.setValue(width, forKey: "width_CD")
        do {
            try context.save()
        } catch {
            print("MarkStore failed to save")
        }}
    
    func getRing(pc: NSPersistentContainer) -> [RingCD] {
        var result: [RingCD] = []
        let context = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RingCD")
        do {
            result = try context.fetch(request) as! [RingCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
    func getRingNamed(_ name: String, pc: NSPersistentContainer) -> [RingCD] {
        var result: [RingCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RingCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [RingCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
    func getRingsIncludedInBL(_ included: Bool, pc: NSPersistentContainer) -> [RingCD] {
        var result: [RingCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "includedInBL_CD == %@", NSNumber(value: included))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RingCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [RingCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func deleteAllRingsFromDB(pc: NSPersistentContainer) {
        pc.performBackgroundTask { (moc) in
            let deletePolygons = NSBatchDeleteRequest(fetchRequest: RingCD.fetchRequest())
            do {
                try moc.execute(deletePolygons)
                try moc.save()
            } catch {
                print("Nope")
            }}}
    
    func deleteRingNamed(_ name: String, pc: NSPersistentContainer){
        var result: [RingCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RingCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [RingCD]
            for r in result {
                pc.viewContext.delete(r)
            }
        } catch {
            print("Failed to retrieve bullseye")
        }}
    
    // MARK: - Placemarks
    func addPlacemark(name: String,
                      longitude: Double,
                      latitude: Double,
                      labelIncluded: Bool,
                      includedInBL: Bool,
                      iconType: String,
                      iconIncluded: Bool,
                      pc: NSPersistentContainer) {
        let context = pc.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PlaceMarkCD", in: context)
        let newPlaceMark = NSManagedObject(entity: entity!, insertInto: context)
        newPlaceMark.setValue(name, forKey: "name_CD")
        newPlaceMark.setValue(longitude, forKey: "longitude_CD")
        newPlaceMark.setValue(latitude, forKey: "latitude_CD")
        newPlaceMark.setValue(labelIncluded, forKey: "labelIncluded_CD")
        newPlaceMark.setValue(includedInBL, forKey: "includedInBL_CD")
        newPlaceMark.setValue(iconType, forKey: "iconType_CD")
        newPlaceMark.setValue(iconIncluded, forKey: "iconIncluded_CD")
        do {
            try context.save()
        } catch {
            print("MarkStore failed to save")
        }}
    
    func getPlacemark(pc: NSPersistentContainer) -> [PlaceMarkCD] {
        var result: [PlaceMarkCD] = []
        let context = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceMarkCD")
        do {
            result = try context.fetch(request) as! [PlaceMarkCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
    func getPlacemarkNamed(_ name: String, pc: NSPersistentContainer) -> [PlaceMarkCD] {
        var result: [PlaceMarkCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceMarkCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [PlaceMarkCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
    func getPlaceMarksIncludedInBL(_ included: Bool, pc: NSPersistentContainer) -> [PlaceMarkCD] {
        var result: [PlaceMarkCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "includedInBL_CD == %@", NSNumber(value: included))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceMarkCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [PlaceMarkCD]
        } catch {
            print("Failed to retrieve bullseye")
        }
        return result
    }
    
    func deleteAllPlacemarksFromDB(pc: NSPersistentContainer) {
        pc.performBackgroundTask { (moc) in
            let deletePolygons = NSBatchDeleteRequest(fetchRequest: PlaceMarkCD.fetchRequest())
            do {
                try moc.execute(deletePolygons)
                try moc.save()
            } catch {
                print("Nope")
            }}}
    
    func deletePlacemarkNamed(_ name: String, pc: NSPersistentContainer){
        var result: [PlaceMarkCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "name_CD == %@", name)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceMarkCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [PlaceMarkCD]
            for r in result {
                pc.viewContext.delete(r)
            }
        } catch {
            print("Failed to retrieve bullseye")
        }}
    
    
    // MARK: - MarkStore
    func deleteAllMarkStoreFromDB(pc: NSPersistentContainer) {
        pc.performBackgroundTask { (moc) in
            let deleteMarkStore = NSBatchDeleteRequest(fetchRequest: MarkStoreCD.fetchRequest())
            do {
                try moc.execute(deleteMarkStore)
                try moc.save()
            } catch {
                print("Nope")
            }}}
    
    func addMarkStore(markBullseyeRefName: String,
                      markPilotAlt: Double,
                      markPilotCoords: [Double],
                      markPilotHeadingTrue: Double,
                      markPilotHeadingMag: Double,
                      markMagVar: Double,
                      markTime: Date,
                      markBearingofPOItoBullsEye: Double,
                      markDistanceofPOItoBullsEye: Double,
                      markPOICoords: String,
                      markPOIUTM: String,
                      markPOIMGRS: String,
                      pc: NSPersistentContainer) {
        let context = pc.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MarkStoreCD", in: context)
        let newMarkStore = NSManagedObject(entity: entity!, insertInto: context)
        newMarkStore.setValue(markBullseyeRefName, forKey: "markBullseyeRefName_CD")
        newMarkStore.setValue(markPilotAlt, forKey: "markPilotAlt_CD")
        newMarkStore.setValue(markPilotCoords, forKey: "markPilotCoords_CD")
        newMarkStore.setValue(markPilotHeadingTrue, forKey: "markPilotHeadingTrue_CD")
        newMarkStore.setValue(markPilotHeadingMag, forKey: "markPilotHeadingMag_CD")
        newMarkStore.setValue(markMagVar, forKey: "markMagVar_CD")
        newMarkStore.setValue(markTime, forKey: "markTime_CD")
        newMarkStore.setValue(markBearingofPOItoBullsEye, forKey: "markBearingofPOItoBullsEye_CD")
        newMarkStore.setValue(markDistanceofPOItoBullsEye, forKey: "markDistanceofPOItoBullsEye_CD")
        newMarkStore.setValue(markPOICoords, forKey: "markPOICoords_CD")
        newMarkStore.setValue(markPOIUTM, forKey: "markPOIUTM_CD")
        newMarkStore.setValue(markPOIMGRS, forKey: "markPOIMGRS_CD")
        do {
            try context.save()
        } catch {
            print("MarkStore failed to save")
        }}
    
    func getMarkStore(pc: NSPersistentContainer) -> [MarkStoreCD] {
        var result: [MarkStoreCD] = []
        let context = pc.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkStoreCD")
        do {
            result = try context.fetch(request) as! [MarkStoreCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
//    func getMarkStoreNamed(_ name: String, pc: NSPersistentContainer) -> [MarkStoreCD] {
//        var result: [MarkStoreCD] = []
//        let context = pc.viewContext
//        let predicate = NSPredicate(format: "name_CD == %@", name)
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkStoreCD")
//        request.predicate = predicate
//        do {
//            result = try context.fetch(request) as! [MarkStoreCD]
//        } catch {
//            print("Failed to retrieve MarkStore")
//        }
//        return result
//    }
    func getMarkStoreNamed(_ time: NSDate, pc: NSPersistentContainer) -> [MarkStoreCD] {
        var result: [MarkStoreCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "markTime_CD == %@", time as CVarArg)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkStoreCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [MarkStoreCD]
        } catch {
            print("Failed to retrieve MarkStore")
        }
        return result
    }
    
    func deleteMarkStoreNamed(_ time: NSDate, pc: NSPersistentContainer){
        var result: [MarkStoreCD] = []
        let context = pc.viewContext
        let predicate = NSPredicate(format: "markTime_CD == %@", time as CVarArg)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkStoreCD")
        request.predicate = predicate
        do {
            result = try context.fetch(request) as! [MarkStoreCD]
            for r in result {
                pc.viewContext.delete(r)
            }
        } catch {
            print("Failed to retrieve bullseye")
        }}
    
  
    
    
    
}



























































