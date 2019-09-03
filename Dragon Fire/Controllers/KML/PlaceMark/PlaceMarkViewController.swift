//
//  PlaceMarkViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/24/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData

class PlaceMarkViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pc = appDelegate.persistentContainer
        placeMarkContainer = cdu.getPlacemark(pc: pc)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.placemarkNameTextFieldOutlet.delegate = self
        self.latLongTextFieldOutlet.delegate = self
        self.hideKeyboardWhenTappedAround()
        setFormatting()
    }
    
    
    // MARK: - Setup
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    let cdu = CoreDataUtilities()
    var placeMarkContainer: [PlaceMarkCD] = []
    var placeMarkName = ""
    var longitude: Double = 0.0 {
        didSet {
            print(longitude)
        }}
    var latitude: Double = 0.0 {
        didSet {
            print(latitude)
        }}
    var validCoords: Bool = false
    var chosenIconType = "forbidden"
    var labelIncluded = true {
        didSet {
            if labelIncluded == true {
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
                print("True")
                inputHeightConstraint.constant = 550
                inputViewOutlet.isHidden = false
                addNewPlaceMarkShowInputOutlet.setImage(upChevron, for: .normal)
            case false:
                print("True")
                inputHeightConstraint.constant = 0
                inputViewOutlet.isHidden = true
                addNewPlaceMarkShowInputOutlet.setImage(downChevron, for: .normal)
                addNewPlaceMarkShowInputOutlet.standardRoundButtonFormatting(cornerRadius: true)
                addNewPlaceMarkShowInputOutlet.layer.cornerRadius = 15
            }}}
    var iconTypeArray = ["forbidden", "blueCircleCircle", "blueCircleDiamond", "blueCircleSquare", "lightBlueCircleCircle", "lightBlueCircleDiamond", "lightBlueCircleSquare", "pinkCircleCircle", "pinkCircleDiamond", "pinkCircleSquare", "purpleCircleCircle", "purpleCircleDiamond", "purpleCircleSquare", "redCircleCircle", "redCircleDiamond", "redCircleSquare", "yellowCircleCircle", "yellowCircleDiamond", "yellowCircleSquare", "whiteCircleCircle", "whiteCircleDiamond", "whiteCircleSquare","bluePin", "greenPin", "lightBluePin","pinkPin","purplePin", "yellowPin", "whitePin"]
    
    // MARK: - Outlets
    @IBOutlet weak var inputViewOutlet: UIView!
    @IBOutlet var inputViewCollection: [UIView]!
    @IBOutlet var switchOutletCollection: [UISwitch]!
    @IBOutlet weak var exportToForeFlightButtonOutlet: UIButton!
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addNewPlaceMarkShowInputOutlet: UIButton!
    @IBOutlet weak var deleteAllButtonOutlet: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var placemarkNameTextFieldOutlet: UITextField!
    @IBOutlet weak var latLongTextFieldOutlet: UITextField!
    @IBOutlet weak var labelIncludedOutlet: UILabel!
    @IBOutlet weak var iconIncludedLabel: UILabel!
    @IBOutlet weak var includedInBLLabel: UILabel!
    @IBOutlet weak var coordInfoButton: UIButton!
    @IBOutlet weak var placeMarkTableView: UITableView!
    
    // MARK: - Buttons and Controls
    @IBAction func placeMarkNameTextField(_ sender: UITextField) {
        //Editing DidChange
        if let placeMarkName_ = placemarkNameTextFieldOutlet.text {
            placeMarkName = placeMarkName_
        }}
    @IBAction func nameTextFieldNextButtonPressed(_ sender: UITextField) {
        //Primary Name TextField Action
        _ = textFieldShouldReturn(sender)
    }
    
    @IBAction func latLongTextField(_ sender: UITextField) {
        //Primary LatLongTextField Action
        latitude = getCoords().lat
        longitude = getCoords().long
    }
    @IBAction func labelIncludedSwitch(_ sender: UISwitch) {
        if sender.isOn {
            labelIncluded = true
        } else {
            labelIncluded = false
        }}
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
    
    
    @IBAction func deleteAllPlacemarksButton(_ sender: UIButton) {
        cdu.deleteAllPlacemarksFromDB(pc: pc)
        placeMarkContainer = cdu.getPlacemark(pc: pc)
        placeMarkTableView.reloadData()
    }
    
    @IBAction func exportToForeFlightButton(_ sender: UIButton) {
        self.passToShareSheetWithfileNamePopupWith(placeHolder: "Placemarks", ext: "kml", stingToWrite: generateKml())
    }
    
    @IBAction func addNewPlacemarkButton(_ sender: UIButton) {
        if validCoords == false {
            let alertController = UIAlertController(title: "Invalid Coords", message:
                "Please recheck the coordinates you've entered.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true)
        } else {
            addNewPlacemarkToCoreData()
            updateTableView()
            print(cdu.getPlacemark(pc: pc).count)
        }}
    
    @IBAction func addNewPlaceMarkShowInputButton(_ sender: UIButton) {
        if showInputView == true {
            showInputView = false
        } else {
            showInputView = true
        }}
    
    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return iconTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenIconType = iconTypeArray[row]
        print(chosenIconType)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: iconTypeArray[row]))
            return myImageView
    }
    
    
    // MARK: - Functions
    func setFormatting() {
        placeMarkTableView.rowHeight = 135
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
        
        placeMarkTableView.layer.borderColor = borderColor
        placeMarkTableView.layer.borderWidth = borderWidth
        placeMarkTableView.layer.cornerRadius = cornerRadius
        
        placemarkNameTextFieldOutlet.layer.borderColor = borderColor
        placemarkNameTextFieldOutlet.layer.borderWidth = borderWidth
        placemarkNameTextFieldOutlet.layer.cornerRadius = cornerRadius
        
        latLongTextFieldOutlet.layer.borderColor = borderColor
        latLongTextFieldOutlet.layer.borderWidth = borderWidth
        latLongTextFieldOutlet.layer.cornerRadius = cornerRadius
        
        exportToForeFlightButtonOutlet.standardButtonFormatting(cornerRadius: true)
        addNewPlaceMarkShowInputOutlet.standardRoundButtonFormatting(cornerRadius: true)
        addNewPlaceMarkShowInputOutlet.layer.cornerRadius = 15
        showInputView = false
        coordInfoButton.standardRoundButtonFormatting(cornerRadius: true)
    }
    
    func addNewPlacemarkToCoreData() {
        let iconType = chosenIconType.switchIconImageNameToHref()
        cdu.addPlacemark(name: placeMarkName,
                         longitude: longitude,
                         latitude: latitude,
                         labelIncluded: labelIncluded,
                         includedInBL: includedInBL,
                         iconType: iconType,
                         iconIncluded: iconIncluded,
                         pc: pc)
        placeMarkContainer = cdu.getPlacemark(pc: pc)
        print(placeMarkContainer.count)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == placemarkNameTextFieldOutlet {
            latLongTextFieldOutlet.becomeFirstResponder()
        } else if textField == latLongTextFieldOutlet {
            textField.resignFirstResponder()
        }
        return true
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
    
    func generateKml() -> String {
        var internalKML = ""
        for placeMark in placeMarkContainer {
            let iconType = IconType(rawValue: placeMark.iconType_CD ?? "http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png")
            internalKML += PlacemarkKML(placeMarkTitle: placeMark.name_CD ?? "None",
                                        placeMarkDescription: "",
                                        placeMarkCoords: [placeMark.longitude_CD, placeMark.latitude_CD],
                                        iconType: iconType ?? .yellowPin,
                                        withLabel: placeMark.labelIncluded_CD,
                                        withIcon: placeMark.iconIncluded_CD).iconGenerator()
        }
        let kml = OpenCloseKML(kmlItems: internalKML).KMLGenerator()
        print(kml)
        return kml
    }
    
    func updateTableView() {
        placeMarkContainer = cdu.getPlacemark(pc: pc)
        placeMarkTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "coordInfoPopup"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }}

    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeMarkContainer.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeMarkCell", for: indexPath) as! PlaceMarkTableViewCell
        let placeMark = placeMarkContainer[indexPath.row]
        let lat = "\(String(format: "%.4f",placeMark.latitude_CD))"
        let lon = "\(String(format: "%.4f",placeMark.longitude_CD))"
        let coords = "\(lat) / \(lon)"
        cell.placeMarksNameLabel.text = placeMark.name_CD
        cell.iconIncludedlLabel.indicatorLabelIsOnRound(placeMark.iconIncluded_CD)
        print(placeMark.iconIncluded_CD)
        cell.nameLabelIncludedlLabel.indicatorLabelIsOnRound(placeMark.labelIncluded_CD)
        cell.iconType.image = UIImage(named: (placeMark.iconType_CD?.switchIcon())!)
        cell.includedInBLLabel.indicatorLabelIsOnRound(placeMark.includedInBL_CD)
        cell.coordslLabel.text = coords
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let placeMarkName = placeMarkContainer[indexPath.row].name_CD {
                
                do {
                    cdu.deletePlacemarkNamed(placeMarkName, pc: pc)
                    placeMarkContainer.remove(at: indexPath.row)
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
    
    
    
    
    
}
