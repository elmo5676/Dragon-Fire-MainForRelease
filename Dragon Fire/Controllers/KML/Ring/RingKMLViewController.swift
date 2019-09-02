//
//  RingKMLViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/22/18.
//  Copyright © 2018 elmo. All rights reserved.
//


import UIKit
import KML
import CoreData
import KML

class RingKMLViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,  UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pc = appDelegate.persistentContainer
        setFormatting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ringNameTextFieldOutlet.delegate = self
        self.latLongTextFieldOutlet.delegate = self
        self.hideKeyboardWhenTappedAround()
        ringsInCoreData = cdu.getRing(pc: pc)
        
    }
    
    
    
    
    // MARK: - Setup
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    let cdu = CoreDataUtilities()
    var ringsInCoreData: [RingCD] = []
    
    var polyOpacity = "0"
    var polyColor = "1400FF"
    var ringName = ""
    var longitude: Double = 0.0 {
        didSet {
            print(longitude)
        }}
    var latitude: Double = 0.0 {
        didSet {
            print(latitude)
        }}
    var validCoords: Bool = false
    var chosenLineThickness = "1"
    var chosenColor = "Black"
    var chosenSize = "5"
    var chosenType = "forbidden"
    var centerLabelIncluded = true {
        didSet {
            if centerLabelIncluded == true {
                labelIncludedOutlet.text = "Included"
            } else {
                labelIncludedOutlet.text = "Omitted"
            }}}
    var iconIncluded = true {
        didSet {
            if iconIncluded == true {
                iconIncludedLabel.text = "Included"
            } else {
                iconIncludedLabel.text = "Omitted"
            }}}
    var includedInBL: Bool = true {
        didSet {
            if includedInBL == true {
                includedInBLLabel.text = "Included"
            } else {
                includedInBLLabel.text = "Omitted"
            }}}
    var showInputView: Bool = false {
        didSet {
            let upChevron = UIImage(named: "icons8-chevron_up_round")
            let downChevron = UIImage(named: "icons8-chevron_down_round")
            switch showInputView {
            case true:
                inputHeightConstraint.constant = 550
                inputViewOutlet.isHidden = false
                addNewRingShowInputOutlet.setImage(upChevron, for: .normal)
            case false:
                inputHeightConstraint.constant = 0
                inputViewOutlet.isHidden = true
                addNewRingShowInputOutlet.setImage(downChevron, for: .normal)
                addNewRingShowInputOutlet.standardRoundButtonFormatting(cornerRadius: true)
                addNewRingShowInputOutlet.layer.cornerRadius = 15
            }}}
    
    var lineThicknessArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    var ringSizeArray = ["5", "10", "20","30","40", "50", "60", "70","80","90", "100", "110", "120", "130", "140", "150", "160", "170", "180", "190", "200", "210", "220", "230", "240", "250", "260", "270", "280", "290", "300"]
    var ringColorArray = ["Black", "Red", "Orange", "LightYellow", "DarkGreen", "Blue"]
    var iconTypeArray = ["forbidden", "blueCircleCircle", "blueCircleDiamond", "blueCircleSquare", "lightBlueCircleCircle", "lightBlueCircleDiamond", "lightBlueCircleSquare", "pinkCircleCircle", "pinkCircleDiamond", "pinkCircleSquare", "purpleCircleCircle", "purpleCircleDiamond", "purpleCircleSquare", "redCircleCircle", "redCircleDiamond", "redCircleSquare", "yellowCircleCircle", "yellowCircleDiamond", "yellowCircleSquare", "whiteCircleCircle", "whiteCircleDiamond", "whiteCircleSquare","bluePin", "greenPin", "lightBluePin","pinkPin","purplePin", "yellowPin", "whitePin"]
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var inputViewOutlet: UIView!
    @IBOutlet var inputViewCollection: [UIView]!
    @IBOutlet var switchOutletCollection: [UISwitch]!
    @IBOutlet weak var exportToForeFlightButtonOutlet: UIButton!
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addNewRingShowInputOutlet: UIButton!
    @IBOutlet weak var deleteAllButtonOutlet: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var ringNameTextFieldOutlet: UITextField!
    @IBOutlet weak var latLongTextFieldOutlet: UITextField!
    @IBOutlet weak var labelIncludedOutlet: UILabel!
    @IBOutlet weak var iconIncludedLabel: UILabel!
    @IBOutlet weak var includedInBLLabel: UILabel!
    @IBOutlet weak var ringTableView: UITableView!
    @IBOutlet weak var coordInfoButton: UIButton!
    
    // MARK: - Functions
    func setFormatting() {
        ringTableView.rowHeight = 135
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let cornerRadius: CGFloat = 5
        for view in inputViewCollection {
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
            view.layer.cornerRadius = cornerRadius
        }
        for eachSwitch in switchOutletCollection {
            eachSwitch.onTintColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
        }
        addButtonOutlet.layer.borderColor = borderColor
        addButtonOutlet.layer.borderWidth = borderWidth
        addButtonOutlet.layer.cornerRadius = cornerRadius
        deleteAllButtonOutlet.layer.borderColor = borderColor
        deleteAllButtonOutlet.layer.borderWidth = borderWidth
        deleteAllButtonOutlet.layer.cornerRadius = cornerRadius
        ringTableView.layer.borderColor = borderColor
        ringTableView.layer.borderWidth = borderWidth
        ringTableView.layer.cornerRadius = cornerRadius
        ringNameTextFieldOutlet.layer.borderColor = borderColor
        ringNameTextFieldOutlet.layer.borderWidth = borderWidth
        ringNameTextFieldOutlet.layer.cornerRadius = cornerRadius
        
        latLongTextFieldOutlet.layer.borderColor = borderColor
        latLongTextFieldOutlet.layer.borderWidth = borderWidth
        latLongTextFieldOutlet.layer.cornerRadius = cornerRadius

        exportToForeFlightButtonOutlet.standardButtonFormatting(cornerRadius: true)
        addNewRingShowInputOutlet.standardRoundButtonFormatting(cornerRadius: true)
        addNewRingShowInputOutlet.layer.cornerRadius = 15
        showInputView = false
        coordInfoButton.standardRoundButtonFormatting(cornerRadius: true)
    }

    func addNewRingToCoreData(){
        cdu.addRing(ringSize: Double(chosenSize) ?? 100,
                    ringIncluded: true,
                    ringColor: chosenColor,
                    polyOpacity: polyOpacity,
                    polyColor: polyColor,
                    name: ringName,
                    longitude: longitude,
                    latitude: latitude,
                    includedInBL_CD: includedInBL,
                    iconType: chosenType,
                    iconIncluded: iconIncluded,
                    width: Int(chosenLineThickness) ?? 5,
                    pc: pc)
    }
    @IBAction func ringNameTextField(_ sender: UITextField) {
        if let ringName_ = ringNameTextFieldOutlet.text {
            ringName = ringName_
        }
    }
    @IBAction func nameTextFieldNextButtonPressed(_ sender: UITextField) {
        _ = textFieldShouldReturn(sender)
    }
    @IBAction func latLongTextField(_ sender: UITextField) {
        latitude = getCoords().lat
        longitude = getCoords().long
    }
    
    @IBAction func iconIncludedSwitch(_ sender: UISwitch) {
        if sender.isOn {
            iconIncluded = true
        } else {
            iconIncluded = false
        }}
    @IBAction func includedInBLSwitch(_ sender: UISwitch) {
        if sender.isOn {
            includedInBL = true
        } else {
            includedInBL = false
        }}
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ringNameTextFieldOutlet {
            latLongTextFieldOutlet.becomeFirstResponder()
        } else if textField == latLongTextFieldOutlet {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func exportToForeFlightButton(_ sender: UIButton) {
        self.passToShareSheetWithfileNamePopupWith(placeHolder: "Rings", ext: "kml", stingToWrite: generateKml())
    }
    
    
    func updateTableView() {
        ringsInCoreData = cdu.getRing(pc: pc)
        ringTableView.reloadData()
    }
    
    func getCoords() -> (lat: Double, long: Double) {
        var lat: Double = 0.0
        var long: Double = 0.0
        do {
            if let latLongString_ = latLongTextFieldOutlet.text {
                let latLong = try LatLon.parseLatLon(stringToParse: latLongString_)
                lat = latLong.toDouble().lat
                long = latLong.toDouble().lon
                latLongTextFieldOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0.9012219906, blue: 0.007557971869, alpha: 1)
                latLongTextFieldOutlet.layer.borderWidth = 1
                validCoords = true
            }
        } catch {
            print(error)
            latLongTextFieldOutlet.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            latLongTextFieldOutlet.layer.borderWidth = 1
            validCoords = false
        }
        return (lat: lat, long: long)
    }
    
    
    @IBAction func addNewRingButton(_ sender: UIButton) {
        if validCoords == false {
            let alertController = UIAlertController(title: "Invalid Coords", message:
                "Please recheck the coordinates you've entered.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true)
        } else {
            addNewRingToCoreData()
            updateTableView()
            print(cdu.getRing(pc: pc).count)
        }
    }
    
    @IBAction func deleteAllRingsButton(_ sender: UIButton) {
        cdu.deleteAllRingsFromDB(pc: pc)
        updateTableView()
    }
    
    @IBAction func addNewPathShowInputViewButton(_ sender: UIButton) {
        switch showInputView {
        case true:
            showInputView = false
        case false:
            showInputView = true
        }
    }
    
    
    
    
    func generateKml() -> String {
        var internalKML = ""
        
        for ring in ringsInCoreData {
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
            print(iconTypehref)
        }
        
        let kml = OpenCloseKML(kmlItems: internalKML).KMLGenerator()
        return kml
    }
    
    //Category Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return ringColorArray.count
        } else if component == 1 {
            return lineThicknessArray.count
        } else if component == 2 {
            return ringSizeArray.count
        } else {
            return iconTypeArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if let chosenColor_ = ColorKML(rawValue: ringColorArray[row].switchColorImageToCode()) {
                chosenColor = chosenColor_.rawValue
            }
//            chosenColor = ringColorArray[row]
            print(chosenColor)
        } else if component == 1 {
            chosenLineThickness = lineThicknessArray[row]
            print(chosenLineThickness)
        } else if component == 2 {
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
            sizeList.text = lineThicknessArray[row]
            sizeList.font = UIFont.boldSystemFont(ofSize: 22)
            return sizeList
        } else if component == 2 {
            let sizeList = UILabel()
            sizeList.textAlignment = .center
            sizeList.text = ringSizeArray[row]
            sizeList.font = UIFont.boldSystemFont(ofSize: 22)
            return sizeList
        } else {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: iconTypeArray[row]))
            return myImageView
        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ringsInCoreData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ringCell", for: indexPath) as! RingTableViewCell
        cell.ringModelLabel.layer.cornerRadius = cell.ringModelLabel.frame.width/2
        cell.ringModelLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.ringModelLabel.layer.borderWidth = 3
        cell.ringNameLabel.text = ringsInCoreData[indexPath.row].name_CD ?? "None"
        let borderWidth = CGFloat(ringsInCoreData[indexPath.row].width_CD)
        cell.ringModelLabel.layer.borderWidth = borderWidth
        let lineColor = ringsInCoreData[indexPath.row].ringColor_CD
        cell.ringModelLabel.layer.borderColor = lineColor!.getCGColor()
    cell.ringFilledInLabel.indicatorLabelIsOnRound(ringsInCoreData[indexPath.row].iconIncluded_CD)
        print("*********************************************")
        print(ringsInCoreData[indexPath.row].iconIncluded_CD)
        print("*********************************************")
    cell.includedInBLLabel.indicatorLabelIsOnRound(ringsInCoreData[indexPath.row].includedInBL_CD)
        
        cell.ringClosedLabel.text = "\(Int(ringsInCoreData[indexPath.row].ringSize_CD))"
        cell.iconType.image = UIImage(named: ringsInCoreData[indexPath.row].iconType_CD ?? "blueCircleDiamond")

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let ring = ringsInCoreData[indexPath.row].name_CD {
                
                do {
                    cdu.deleteRingNamed(ring, pc: pc)
                    ringsInCoreData.remove(at: indexPath.row)
                    try pc.viewContext.save()
                    tableView.deleteRows(at: [indexPath], with: .fade) //This line reloads the data automatically
                } catch {
                    print(error)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "coordInfoPopupSegueRing"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }


    
    
    

    

}
