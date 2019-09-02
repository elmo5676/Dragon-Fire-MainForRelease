//
//  DivertKMLViewController.swift
//  Dragon Fire
//
//  Created by elmo on 6/15/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData
import KML

class DivertKMLViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFormatting()
        pc = appDelegate.persistentContainer
        divertFieldsOutlet.allowsSelection = false
    }
    override func viewWillAppear(_ animated: Bool) {
        divertTable = cdu.getDivertFields(pc: pc)
        hideAndDisplayInput()
    }
    
    // MARK: - Setup
    let categories = ["1","2","3","4"]
    var ringSizeArray = ["50", "60", "70","80","90", "100", "110", "120", "130", "140", "150", "160", "170", "180", "190", "200", "210", "220", "230", "240", "250", "260", "270", "280", "290", "300"]
    var ringColorArray = ["Black", "Red", "Orange", "LightYellow", "DarkGreen", "Blue"]
    var iconTypeArray = ["forbidden", "blueCircleCircle", "blueCircleDiamond", "blueCircleSquare", "lightBlueCircleCircle", "lightBlueCircleDiamond", "lightBlueCircleSquare", "pinkCircleCircle", "pinkCircleDiamond", "pinkCircleSquare", "purpleCircleCircle", "purpleCircleDiamond", "purpleCircleSquare", "redCircleCircle", "redCircleDiamond", "redCircleSquare", "yellowCircleCircle", "yellowCircleDiamond", "yellowCircleSquare", "whiteCircleCircle", "whiteCircleDiamond", "whiteCircleSquare","bluePin", "greenPin", "lightBluePin","pinkPin","purplePin", "yellowPin", "whitePin"]
    let cdu = CoreDataUtilities()
    var airfieldSearchedFor: [AirfieldCD] = []
    var chosenAirfieldsInTable: [AirfieldCD] = []
    var chosenColor = "Black"
    var chosenSize = "160"
    var chosenType = "forbidden"
    var divertTable: [DivertFieldsCD] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    var inputIsHidden = false {
        didSet {
            inputIsHidden(inputIsHidden)
        }}
    var centerLabelIncluded = true {
        didSet {
            if centerLabelIncluded == true {
                labelIncludedLabel.text = "Included"
            } else {
                labelIncludedLabel.text = "Omitted"
            }}}
    var iconIncluded = true {
        didSet {
            if iconIncluded == true {
                iconIncludedLabel.text = "Included"
            } else {
                iconIncludedLabel.text = "Omitted"
            }}}
    var ringIncluded = true {
        didSet {
            if ringIncluded == true {
                ringIncludedLabel.text = "Included"
            } else {
                ringIncludedLabel.text = "Omitted"
            }}}
    
    var chosenAirfield: AirfieldCD? {
        didSet {
            icaoLabel.text = chosenAirfield?.icao_CD
            airfieldNameLabel.text = chosenAirfield?.name_CD
        }}
    var includedInBL: Bool = true {
        didSet {
            if includedInBL == true {
                includedInBLLabel.text = "Included"
            } else {
                includedInBLLabel.text = "Omitted"
            }}}
        
    // MARK: - Outlets
    @IBOutlet weak var searchButtonOutlet: UIButton!
    @IBOutlet weak var ICAOTextFieldOutlet: UITextField!
    @IBOutlet weak var inputViewOutlet: UIView!
    @IBOutlet weak var inputHeightConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var icaoLabel: UILabel!
    @IBOutlet weak var airfieldNameLabel: UILabel!
    //Controls:
    @IBOutlet weak var pickerViewOutlet: UIView!
    @IBOutlet weak var switchViewOutlet: UIView!
    @IBOutlet weak var nameICAOViewOutlet: UIView!
    @IBOutlet weak var annotationPickerView: UIPickerView!
    @IBOutlet weak var labelIncludedSwitchOutlet: UISwitch!
    @IBOutlet weak var iconIncludedSwitchOutlet: UISwitch!
    @IBOutlet weak var ringIncludedSwitchOutlet: UISwitch!
    @IBOutlet weak var includedInBLSwitchOutlet: UISwitch!
    @IBOutlet weak var labelIncludedLabel: UILabel!
    @IBOutlet weak var iconIncludedLabel: UILabel!
    @IBOutlet weak var ringIncludedLabel: UILabel!
    @IBOutlet weak var includedInBLLabel: UILabel!
    @IBOutlet weak var addFieldButtonOutlet: UIButton!
    //Divert Fields Table:
    @IBOutlet weak var divertFieldsOutlet: UITableView!
    @IBOutlet weak var deleteAllButtonOutlet: UIButton!
    @IBOutlet weak var includedDivertLabel: UILabel!
    @IBOutlet weak var includedDivertButtonOutlet: UIButton!
    
    
    // MARK: - Functions
    func hideAndDisplayInput() {
        if inputIsHidden == true {
            inputIsHidden = false
        } else {
            inputIsHidden = true
        }
    }
    func setFormatting() {
        let cornerRadius: CGFloat = 5
        self.annotationPickerView.selectRow(11, inComponent: 1, animated: false)
        nameICAOViewOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nameICAOViewOutlet.layer.borderWidth = 1
        nameICAOViewOutlet.layer.cornerRadius = cornerRadius
        pickerViewOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pickerViewOutlet.layer.borderWidth = 1
        pickerViewOutlet.layer.cornerRadius = cornerRadius
        switchViewOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        switchViewOutlet.layer.borderWidth = 1
        switchViewOutlet.layer.cornerRadius = cornerRadius
        ICAOTextFieldOutlet.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        ICAOTextFieldOutlet.layer.borderWidth = 1
        inputViewOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        inputViewOutlet.layer.borderWidth = 1
        inputViewOutlet.layer.cornerRadius = cornerRadius
        searchButtonOutlet.standardButtonFormatting(cornerRadius: false)
        searchButtonOutlet.layer.cornerRadius = 15
        addFieldButtonOutlet.standardButtonFormatting(cornerRadius: false)
        addFieldButtonOutlet.layer.cornerRadius = cornerRadius
        labelIncludedSwitchOutlet.onTintColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
        iconIncludedSwitchOutlet.onTintColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
        ringIncludedSwitchOutlet.onTintColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
        includedInBLSwitchOutlet.onTintColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
        deleteAllButtonOutlet.layer.cornerRadius = cornerRadius
        deleteAllButtonOutlet.layer.borderWidth = 1
        deleteAllButtonOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        exportToForeFlightButtonOutlet.standardButtonFormatting(cornerRadius: true)
        exportToForeFlightButtonOutlet.layer.cornerRadius = (exportToForeFlightButtonOutlet.frame.width)/10
        divertFieldsOutlet.layer.borderWidth = 1
        divertFieldsOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        divertFieldsOutlet.layer.cornerRadius = cornerRadius
        includedDivertLabel.layer.cornerRadius = cornerRadius
        includedDivertLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        includedDivertLabel.layer.borderWidth = 1
        includedDivertButtonOutlet.layer.cornerRadius = cornerRadius
        divertFieldsOutlet.rowHeight = 120
    }
    
    func inputIsHidden(_ av: Bool) {
        inputViewOutlet.isHidden = av
        addFieldButtonOutlet.isHidden = av
        if av == true {
            inputHeightConstraintOutlet.constant = 0
        } else {
            inputHeightConstraintOutlet.constant = 550
        }}
    
    func generateKML() -> String {
        var internalKML = ""
        for divert in divertTable {
            var ring = ""
            if divert.ringIncluded_CD == true {
                ring = CircleKML(radius: divert.ringSize_CD,
                                 centerPoint: [divert.longitude_CD, divert.latitude_CD],
                                 centerpointLabelTitle: divert.icao_CD!,
                                 lineColor: ColorKML(rawValue: divert.ringColor_CD!.switchColorImageToCode())!,
                                 iconType: IconType(rawValue: (divert.iconType_CD?.switchIconImageNameToHref())!)!,
                                 iconIncluded: divert.iconIncluded_CD,
                                 centerpointLabelIncluded: divert.icaoLabelIncluded_CD,
                                 width: 5).circleWithCenterLabel_()
            } else {
                ring = PlacemarkKML(placeMarkTitle: divert.icao_CD!,
                                    placeMarkDescription: "",
                                    placeMarkCoords: [divert.longitude_CD, divert.latitude_CD],
                                    iconType: IconType(rawValue: (divert.iconType_CD?.switchIconImageNameToHref())!)! ,
                                    withLabel: divert.icaoLabelIncluded_CD,
                                    withIcon: divert.iconIncluded_CD).iconGenerator()
            }
            internalKML += ring
            print(ColorKML(rawValue: divert.ringColor_CD!.switchColorImageToCode())!)
            print(IconType(rawValue: (divert.iconType_CD?.switchIconImageNameToHref())!)!)
        }
        print(divertTable)
        print(divertTable.count)
        let kml = OpenCloseKML(kmlItems: internalKML).KMLGenerator()
        return kml
    }
    
    // MARK: - Seque Stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "searchForICAO"?:
            let destinationViewController = segue.destination as! DivertFieldsTableViewController
            destinationViewController.airfields = airfieldSearchedFor
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }}
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let source = segue.source as? DivertFieldsTableViewController
        chosenAirfield = (source?.chosenAirfield)
        hideAndDisplayInput()
        self.view.endEditing(true)
        ICAOTextFieldOutlet.text = ""
    }

    // MARK: - Buttons & Controls
    //ICAO Search
    @IBAction func icaoSearchTextFieldAction(_ sender: UITextField) {
    }
    
    var userLat: String = "" {didSet {userLatDouble = userLat.latitudeTranslate()}}
    var userLong: String = "" {didSet {userLongDouble = userLong.longitudeTranslate()}}
    var userICAO: String = ""
    var userLatDouble: Double = 0.0
    var userLongDouble: Double = 0.0
    
    var userLatTextField: UITextField?
    var userLongTextField: UITextField?
    var userICAOTextField: UITextField?
    func userLatTextField(textField: UITextField!) {
        userLatTextField = textField
        userLatTextField?.placeholder = "DDMM.ddN"
    }
    func userLongTextField(textField: UITextField!) {
        userLongTextField = textField
        userLongTextField?.placeholder = "DDDMM.ddW"
    }
    @IBOutlet weak var icaoSearchTextfieldOutlet: UITextField!
    func userICAOTextField(textField: UITextField!) {
        userICAOTextField = textField
        userICAOTextField?.text = icaoSearchTextfieldOutlet.text
    }
    func userLatLongHandler(alert: UIAlertAction!) {
        userLat = (userLatTextField?.text?.capitalized)!
        userLong = (userLongTextField?.text?.capitalized)!
        userICAO = (userICAOTextField?.text?.uppercased())!
        icaoLabel.text = (userICAOTextField?.text?.uppercased())!
        airfieldNameLabel.text = (userICAOTextField?.text?.uppercased())!
        hideAndDisplayInput()
    }
    
    @IBAction func icaoSearchTextField(_ sender: Any) {
        let icao = ICAOTextFieldOutlet.text!
        var airfields: [AirfieldCD] = []
        if icao != "" {
            airfields = cdu.getAirfieldByICAO_(icao, pc: pc)
        }
        if airfields.count == 0 {
            let alertController = UIAlertController(title: "No Matches", message:
                "Either check your entry and try again or enter custom airfield information and press the Custom button", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil))
            alertController.addTextField(configurationHandler: userLatTextField)
            alertController.addTextField(configurationHandler: userLongTextField)
            alertController.addTextField(configurationHandler: userICAOTextField)
            let customAction = UIAlertAction(title: "Custom", style: .default, handler: self.userLatLongHandler)
            alertController.addAction(customAction)
            self.present(alertController, animated: true)
            return
        }
        airfieldSearchedFor = airfields
        performSegue(withIdentifier: "searchForICAO", sender: nil)
    }
    
    
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return ringColorArray.count
        } else if component == 1 {
            return ringSizeArray.count
        } else {
            return iconTypeArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            chosenColor = ringColorArray[row]
            print(chosenColor)
        } else if component == 1 {
            chosenSize = ringSizeArray[row]
            print(chosenSize)
        } else {
            chosenType = iconTypeArray[row]
            print(chosenType)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return ringSizeArray[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 0 {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: ringColorArray[row]))
            return myImageView
        } else if component == 1 {
            let sizeList = UILabel()
            sizeList.textAlignment = .center
            sizeList.text = ringSizeArray[row]
            sizeList.font = UIFont.boldSystemFont(ofSize: 22)
            return sizeList
        } else {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: iconTypeArray[row]))
            return myImageView
        }}
        
    
    //Switchs
    @IBAction func labelIncludedSwitch(_ sender: AnyObject) {
        if sender.isOn {
            centerLabelIncluded = true
        } else {
            centerLabelIncluded = false
        }}
    @IBAction func iconIncludedSwitch(_ sender: AnyObject) {
        if sender.isOn {
            iconIncluded = true
        } else {
            iconIncluded = false
        }}
    @IBAction func ringIncludedSwitch(_ sender: AnyObject) {
        if sender.isOn {
            ringIncluded = true
        } else {
            ringIncluded = false
        }}
    @IBAction func includedInBLSwitch(_ sender: AnyObject) {
        if sender.isOn {
            includedInBL = true
        } else {
            includedInBL = false
        }}
    
    //Add airfield to table
    @IBAction func addAirfieldToDivertsButton(_ sender: UIButton) {
        if let caf = chosenAirfield {
            cdu.addDivertField(icao: caf.icao_CD!,
                               includedInBL: self.includedInBL,
                               latitude: caf.latitude_CD,
                               longitude: caf.longitude_CD,
                               name: caf.name_CD!,
                               ringColor: self.chosenColor,
                               ringSize: Double(self.chosenSize)!,
                               iconType: self.chosenType,
                               iconIncluded: self.iconIncluded,
                               ringIncluded: self.ringIncluded,
                               icaoLabelIncluded: self.centerLabelIncluded, pc: pc)
        } else {
            cdu.addDivertField(icao: userICAO,
                               includedInBL: self.includedInBL,
                               latitude: userLatDouble,
                               longitude: userLongDouble,
                               name: userICAO,
                               ringColor: self.chosenColor,
                               ringSize: Double(self.chosenSize)!,
                               iconType: self.chosenType,
                               iconIncluded: self.iconIncluded,
                               ringIncluded: self.ringIncluded,
                               icaoLabelIncluded: self.centerLabelIncluded, pc: pc)
        }
        divertTable = cdu.getDivertFields(pc: pc)
        print(divertTable)
        divertFieldsOutlet.reloadData()
        hideAndDisplayInput()
        chosenAirfield = nil
    }
    
    
    @IBAction func deleteAllDivertsFromCDButton(_ sender: UIButton) {
        if cdu.getDivertFields(pc: pc).count > 0 {
            cdu.deleteAllDivertsFromDB_(pc: pc)
            divertTable = cdu.getDivertFields(pc: pc)
        }
        divertFieldsOutlet.reloadData()
    }
    
    //DiverFields Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return divertTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "divertField", for: indexPath) as! ListOfDivertsTableViewCell
        cell.icaoLabel?.text = divertTable[indexPath.row].icao_CD
        cell.nameLabel?.text = divertTable[indexPath.row].name_CD
        cell.ringColorImage.image = UIImage(named: divertTable[indexPath.row].ringColor_CD!)
        cell.iconTypeImage.image = UIImage(named: divertTable[indexPath.row].iconType_CD!)
        cell.ringColorImage.layer.cornerRadius = 5
        cell.ringColorImage.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.3333333333, blue: 0.3921568627, alpha: 1)
        cell.ringColorImage.layer.borderWidth = 1
        cell.ringSizeLabel.text = "\(String(format: "%.0f",divertTable[indexPath.row].ringSize_CD))NM"
        cell.icaoLabelIncludedLabel.indicatorLabelIsOn(divertTable[indexPath.row].icaoLabelIncluded_CD)
        cell.iconIncludedLabel.indicatorLabelIsOn(divertTable[indexPath.row].iconIncluded_CD)
        cell.ringIncludedLabel.indicatorLabelIsOn(divertTable[indexPath.row].ringIncluded_CD)
        cell.includedInBLLabel.indicatorLabelIsOn(divertTable[indexPath.row].includedInBL_CD)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let icao = divertTable[indexPath.row].icao_CD {
                
                do {
                    cdu.deleteDivertwithIcao(icao, pc: pc)
                    divertTable.remove(at: indexPath.row)
                    try pc.viewContext.save()
                    tableView.deleteRows(at: [indexPath], with: .fade) //This line reloads the data automatically
                } catch {
                    print(error)
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // MARK: Bottom Buttons
    @IBAction func exportToForeFlight(_ sender: UIButton) {
        self.passToShareSheetWithfileNamePopupWith(placeHolder: "Diverts", ext: "kml", stingToWrite: generateKML())
    }
    
    @IBOutlet weak var includedInBLKMLButtonOutlet: UIButton!
    @IBAction func includedInBLKMLButton(_ sender: UIButton) {
        let redButton = UIImage(named:"notIncludedInBL.png")!
        let greenButton = UIImage(named:"includedInBL.png")!
        if includedInBLKMLButtonOutlet.currentImage == redButton {
            includedInBLKMLButtonOutlet.setImage(greenButton, for: .normal)
        } else {
            includedInBLKMLButtonOutlet.setImage(redButton, for: .normal)
        }
    }
    @IBOutlet weak var exportToForeFlightButtonOutlet: UIButton!
    @IBAction func exportToForeFlightButton(_ sender: UIButton) {
    }
}

