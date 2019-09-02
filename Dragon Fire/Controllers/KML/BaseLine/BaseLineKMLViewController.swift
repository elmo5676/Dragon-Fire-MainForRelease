//
//  BaseLineViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/21/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData
import KML


class BaseLineKMLViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pc = appDelegate.persistentContainer
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getAllCoreData()
        tableSectionCells = [bullsEyeContainer,divertFieldContainer,pathContainer,ringContainer,placemarkContainer]
        setFormatting()
    }
    
    
    let cdu = CoreDataUtilities()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    var tableSections = ["BULLSEYE/SARDOT","DIVERT FIELDS","PATHS","RINGS","PLACEMARKS"]
    var bullsEyeContainer: [BullseyeCD] = []
    var divertFieldContainer: [DivertFieldsCD] = []
    var pathContainer: [PolygonCD] = []
    var ringContainer: [RingCD] = []
    var placemarkContainer: [PlaceMarkCD] = []
    var tableSectionCells: [[Any]] = []
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var exportToForeFlightButton: UIButton!
    
    func getAllCoreData(){
        bullsEyeContainer = cdu.getBullseyeIncludedInBL(true, pc: pc)
        divertFieldContainer = cdu.getDivertFieldsIncludedInBL(true, pc: pc)
        pathContainer = cdu.getPolygonsIncludedInBL(true, pc: pc)
        ringContainer = cdu.getRingsIncludedInBL(true, pc: pc)
        placemarkContainer = cdu.getPlaceMarksIncludedInBL(true, pc: pc)
        print(pathContainer.count)
    }
    
    func createInternalRingKML() -> String {
        var internalKML = ""
        for ring in ringContainer {
            let centerpoint = [ring.longitude_CD, ring.latitude_CD]
            let radius = ring.ringSize_CD/2
            let iconTypehref = (ring.iconType_CD ?? "forbidden").switchIconImageNameToHref()
            
            internalKML += CircleKML(radius: radius,
                                     centerPoint: centerpoint,
                                     centerpointLabelTitle: ring.name_CD ?? "None",
                                     lineColor: ColorKML(rawValue: ring.ringColor_CD ?? "000000") ?? .black,
                                     iconType: IconType(rawValue: iconTypehref) ?? .forbidden,
                                     iconIncluded: ring.iconIncluded_CD,
                                     centerpointLabelIncluded: true,
                                     width: Int(ring.width_CD)).circleWithCenterLabel_()
        }
        return internalKML
    }
   
    
    func createInternalPlacemarkKML() -> String {
        var placemarkKML = ""
        
        return placemarkKML
    }
    
    func createInternalBullseyeKML() -> String {
        var beKML = ""
        for be in bullsEyeContainer {
            let beKMLInstance = BullsEyeKML(bullsEyeName: be.bullsEyeName_CD ?? "BE",
                                            centerPoint: be.centerPoint_CD ?? [0.0,0.0],
                                            radiusOfOuterRing: be.radiusOfOuterRing_CD,
                                            magVariation: be.magVariation_CD,
                                            lineColor: ColorKML(rawValue: be.lineColor_CD ?? "000000") ?? .black,
                                            centerpointLabel: be.centerpointLabel_CD,
                                            rangeLabels: be.rangeLabels_CD,
                                            bearingLabels: be.bearingLabels_CD,
                                            centerpointIcon: IconType(rawValue: be.centerpointIcon_CD!)!,
                                            rangeBearingIconType:  IconType(rawValue: be.rangeBearingIconType_CD!)!,
                                            centerpointIconIncluded: be.centerpointIconIncluded_CD,
                                            rangeIconsIncluded: be.rangeIconsIncluded_CD,
                                            bearingIconsIncluded: be.bearingIconsIncluded_CD).BEKmlGenerator()
            beKML += beKMLInstance
        }
        return beKML
    }
    
    func createInternalDivertFieldsKML() -> String {
        var internalKML = ""
        for divert in divertFieldContainer {
            let ring = CircleKML(radius: divert.ringSize_CD,
                                 centerPoint: [divert.longitude_CD, divert.latitude_CD],
                                 centerpointLabelTitle: divert.icao_CD!,
                                 lineColor: ColorKML(rawValue: divert.ringColor_CD!.switchColorImageToCode())!,
                                 iconType: IconType(rawValue: (divert.iconType_CD?.switchIconImageNameToHref())!)!,
                                 iconIncluded: divert.iconIncluded_CD,
                                 centerpointLabelIncluded: divert.icaoLabelIncluded_CD,
                                 width: 5).circleWithCenterLabel_()
            internalKML += ring
        }
        return internalKML
    }
    
    func createInternalPathKML() -> String {
        var pathKML = ""
        for path in pathContainer {
            let pathInstance = PolygonKML(name: path.name_CD ?? "Path",
                                          description: path.description,
                                          extrude: .off,
                                          tesselate: .off,
                                          altMode: .absolute,
                                          coords: path.coords_CD!,
                                          lineColor: ColorKML(rawValue: path.lineColor_CD!)!,
                                          lineOpacity: Transparency(rawValue: path.lineOpacity_CD!)!,
                                          polyColor: ColorKML(rawValue: path.polyColor_CD!)!,
                                          polyOpacity: Transparency(rawValue: path.polyOpacity_CD!)!,
                                          width: Int(path.width_CD))
            if path.closed_CD == true {
                pathKML += pathInstance.filledInPolygon()
            } else {
                pathKML += pathInstance.lineGenerator()
            }}
        return pathKML
    }
    
    
    func setFormatting() {
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let cornerRadius: CGFloat = 5
        
        resultsTableView.layer.borderColor = borderColor
        resultsTableView.layer.borderWidth = borderWidth
        resultsTableView.layer.cornerRadius = cornerRadius
        exportToForeFlightButton.standardButtonFormatting(cornerRadius: true)
        
    }
    
    func generateKml() -> String {
        let internalKMl = "\(createInternalBullseyeKML()) \(createInternalPathKML()) \(createInternalDivertFieldsKML()) \(createInternalRingKML()) \(createInternalPlacemarkKML())"
        let kml = OpenCloseKML(kmlItems: internalKMl).KMLGenerator()
        return kml
    }
    
    @IBAction func exportKMLToForeFlightButton(_ sender: UIButton) {
        passToShareSheetWithfileNamePopupWith(placeHolder: "Baseline", ext: "kml", stingToWrite: generateKml())
    }
    
    
    
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableSections[section]

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "baseLineCell", for: indexPath) as! BaseLineTableViewCell
        let section = indexPath.section
        let item = tableSectionCells[section]
        switch section {
        case 0:
            var iArray = item as! [BullseyeCD]
            iArray = bullsEyeContainer
            cell.nameLabel?.text = iArray[indexPath.row].bullsEyeName_CD ?? "None"
            print("BE: \(iArray.count)")
        case 1:
            var iArray = item as! [DivertFieldsCD]
            iArray = divertFieldContainer
            cell.nameLabel?.text = iArray[indexPath.row].name_CD ?? "None"
            print("Diverts: \(iArray.count)")
        case 2:
            var iArray = item as! [PolygonCD]
            iArray = pathContainer
            cell.nameLabel?.text = iArray[indexPath.row].name_CD ?? "None"
            print("Path: \(iArray.count)")
        case 3:
            var iArray = item as! [RingCD]
            iArray = ringContainer
            print("Rings: \(iArray.count)")
            cell.nameLabel?.text = iArray[indexPath.row].name_CD ?? "None"
        case 4:
            var iArray = item as! [PlaceMarkCD]
            iArray = placemarkContainer
            cell.nameLabel?.text = iArray[indexPath.row].name_CD ?? "None"
            print("PlaceMarks: \(iArray.count)")
        default:
            print("default")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bullsEyeContainer.count
        case 1:
            return divertFieldContainer.count
        case 2:
            return pathContainer.count
        case 3:
            return ringContainer.count
        case 4:
            return placemarkContainer.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = #colorLiteral(red: 0.9961829782, green: 1, blue: 0.6791642308, alpha: 1)
    }
    


}
