//
//  BullsEyeKMLViewController.swift
//  Dragon Fire
//
//  Created by elmo on 6/15/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class BullsEyeKMLViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {

    // MARK: - Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.bullseyeNameTextfield.delegate = self
        self.coordsTextFieldOutlet.delegate = self
        pc = appDelegate.persistentContainer
    }

    override func viewWillAppear(_ animated: Bool) {
        setButtonFormatting(buttonArray: buttonFormattingArray)
        setFrameFormatting(outletArray: inputOutlets)
        setFormatting()
    }
    
    func setFormatting() {
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let cornerRadius: CGFloat = 5
        exportToForeFlightButtonOutlet.standardButtonFormatting(cornerRadius: true)
        bullseyeNameTextfield.layer.borderColor = borderColor
        bullseyeNameTextfield.layer.borderWidth = borderWidth
        bullseyeNameTextfield.layer.cornerRadius = cornerRadius
        
        coordsTextFieldOutlet.layer.borderColor = borderColor
        coordsTextFieldOutlet.layer.borderWidth = borderWidth
        coordsTextFieldOutlet.layer.cornerRadius = cornerRadius
        coordInfoButton.standardRoundButtonFormatting(cornerRadius: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(cdu.getSarDot(pc: pc))
        print(cdu.getBullseye(pc: pc))
        getpositionPermission()
        isLoactionAvailable()
        magVariationLabel.text = "\(String(format: "%.1f", currentMagVar))°"
    }
    
    // MARK: - Setup
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    let cdu = CoreDataUtilities()
    let locManager = CLLocationManager()
    var isItABullseye = true
    var beOrSd = "BE" {
        didSet {
            if beOrSd == "BE" {
                tiltleLabel.text = "BULLSEYE"
                isItABullseye = true
            } else {
                tiltleLabel.text = "SAR/DOT"
                isItABullseye = false
            }}}
    
    //Name of BE or SAR/DOT
    var nameBE: String = "" {
        didSet {
        }}
    var centerPointLatitudeDouble: Double = 0.0
    var centerPointLongitudeDouble: Double = 0.0
    var coordString: String = "" {
        didSet {
            do {
                let latLon = try LatLon.parseLatLon(stringToParse: coordString)
                coordValidationTextfieldFormatting(valid: true)
                centerPointLatitudeDouble = latLon.toDouble().lat
                centerPointLongitudeDouble = latLon.toDouble().lon
                print(centerPointLatitudeDouble)
                print(centerPointLongitudeDouble)
            } catch {
                coordValidationTextfieldFormatting(valid: false)
                print(error)
            }}}

    
    //Size of Annotation
    var sizeBE: String = "100" {
        didSet {
            if sizeBE != "" || sizeBE != "---" {
                if let sizeDoubleBE_ = Double(sizeBE) {
                    sizeDoubleBE = sizeDoubleBE_
                }
            }}}
    var sizeDoubleBE: Double = 100
    
    var lineWidth: String = "5" {
        didSet {
            print(lineWidth)
        }
    }
    
    //Magnetic Variation
    var magVarBE: Double = 0.0 {
        didSet {
            magVariationLabel.text = "\(String(format: "%.1f", magVarBE))°"
        }}
    var currentMagVar = 0.0
    var positionAvailable = true {
        didSet {
            currentMagVarAvailableIndicatorLabel.layer.cornerRadius = currentMagVarAvailableIndicatorLabel.frame.width/2
            currentMagVarAvailableIndicatorLabel.layer.borderColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
            currentMagVarAvailableIndicatorLabel.layer.borderWidth = 2
            if positionAvailable == true {
                currentMagVarAvailableIndicatorLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9800079465, blue: 0.1043435559, alpha: 1)
                currentMagVarLocOutlet.isEnabled = true
            } else {
                currentMagVarAvailableIndicatorLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1475811303, blue: 0, alpha: 1)
                currentMagVarLocOutlet.isEnabled = false
            }}}
    
    //Labeles included in layer or not
    var centerpointLabelBE = true {
        didSet {
            if self.centerpointLabelBE == true {
                centerpointIncludedLabel.text = "Included"
                centerpointSwitchOutlet.isOn = true
            } else {
                centerpointIncludedLabel.text = "Omitted"
                centerpointSwitchOutlet.isOn = false
            }}}
    var rangeLabelBE = true {
        didSet {
            if self.rangeLabelBE == true {
                rangeIncludedLabel.text = "Included"
                rangeSwitchOutlet.isOn = true
            } else {
                rangeIncludedLabel.text = "Omitted"
                rangeSwitchOutlet.isOn = false
            }}}
    var bearingLabelBE = true {
        didSet {
            if self.bearingLabelBE == true {
                bearingIncludedLabel.text = "Included"
                bearingSwitchOutlet.isOn = true
            } else {
                bearingIncludedLabel.text = "Omitted"
                bearingSwitchOutlet.isOn = false
            }}}
    
    var centerpointIconIncludedBE = true {
        didSet {
            if self.centerpointIconIncludedBE == true {
                centerpointIconLabel.text = "Included"
                centerpointIconSwitchOutlet.isOn = true
            } else {
                centerpointIconLabel.text = "Omitted"
                centerpointIconSwitchOutlet.isOn = false
            }}}
    var centerpointIconBE: IconType = .forbidden  {
        didSet {
        }}
    
    var rangeBearingIconsIncludedBE = true {
        didSet {
            if self.rangeBearingIconsIncludedBE == true {
                rangeBearingIconsIncludedLabel.text = "Included"
                rangeBearingIconsSwitchOutlet.isOn = true
            } else {
                rangeBearingIconsIncludedLabel.text = "Omitted"
                rangeBearingIconsSwitchOutlet.isOn = false
            }}}
    
    var rangeBearingIconBE: IconType = .bluePin  {
        didSet {
        }}
    
    var lineColorBE: ColorKML = .black {
        didSet {
        }}
    var lineOpacityBE: Transparency = ._100 {
        didSet {
        }}
    var lineThicknessBE: Int16 = 4 {
        didSet {
        }}
    var polyColorBE: Transparency = ._0 {
        didSet {
        }}
    var polyOpacityBE: ColorKML = .black {
        didSet {
        }}
    
    //Annotation included in the Baseline KML file chosen
    var includedInBlBE = true {
        didSet {
            if self.includedInBlBE == true {
                includedInBLKMLLabel.text = "Included"
                includedInBLKMLSwitchOutlet.isOn = true
            } else {
                includedInBLKMLLabel.text = "Omitted"
                includedInBLKMLSwitchOutlet.isOn = false
            }}}
    var exportToForeFlight = ["","",""] {
        didSet {
            self.passToShareSheet(fileName: exportToForeFlight[0],
                             ext: exportToForeFlight[1],
                             stringToWriteToFile: exportToForeFlight[2])
        }}
//|| latitudeTextfield.text == "" || longitudeTextfield.text == ""
    func validateTextFields() -> Bool {
        var allFieldsValid = true
        if bullseyeNameTextfield.text == ""   {
            let alertController = UIAlertController(title: "Missing Information", message:
                "Please make sure you have entered a name and coordinates for the Bulls Eye or SARDOT you want to save.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true)
            allFieldsValid = false
        }
        return allFieldsValid
    }
    
    
    // MARK: - Outlets
    //MARK: Title
    @IBOutlet weak var tiltleLabel: UILabel!
    @IBOutlet weak var titleBackbroundBlurTop: UIView!
    @IBOutlet weak var beOrSardotButtonOutlet: UIButton!
    //MARK: TextFields
    @IBOutlet weak var bullseyeNameTextfield: UITextField!
    @IBOutlet weak var coordsTextFieldOutlet: UITextField!
    //MARK: Size Picker
    @IBOutlet weak var sizePickerView: UIPickerView!
    //MARK: Mag Variation
    @IBOutlet weak var magVariationLabel: UILabel!
    @IBOutlet weak var magVarStepperOutlet: UIStepper!
    @IBOutlet weak var currentMagVarLocOutlet: UIButton!
    @IBOutlet weak var currentMagVarAvailableIndicatorLabel: UILabel!
    //MARK: Label controls
    @IBOutlet weak var centerpointIncludedLabel: UILabel!
    @IBOutlet weak var rangeIncludedLabel: UILabel!
    @IBOutlet weak var bearingIncludedLabel: UILabel!
    @IBOutlet weak var centerpointIconLabel: UILabel!
    @IBOutlet weak var rangeBearingIconsIncludedLabel: UILabel!
    @IBOutlet weak var centerpointSwitchOutlet: UISwitch!
    @IBOutlet weak var rangeSwitchOutlet: UISwitch!
    @IBOutlet weak var bearingSwitchOutlet: UISwitch!
    @IBOutlet weak var centerpointIconSwitchOutlet: UISwitch!
    @IBOutlet weak var rangeBearingIconsSwitchOutlet: UISwitch!
    //MARK: Current Bullseye
    @IBOutlet weak var includedInBLKMLSwitchOutlet: UISwitch!
    @IBOutlet weak var includedInBLKMLLabel: UILabel!
    //MARK: Bottom Buttons
    @IBOutlet weak var clearAllInputButtonOutlet: UIButton!
    @IBOutlet weak var saveBullseyeButtonOutlet: UIButton!
    @IBOutlet weak var titleBackbroundBlurBottom: UIView!
    @IBOutlet weak var foreflightView: UIView!
    @IBOutlet weak var exportToForeFlightButtonOutlet: UIButton!
    //MARK: Formatting Arrays
    @IBOutlet var buttonFormattingArray: [UIButton]!
    @IBOutlet var inputOutlets: [UIView]!
    
    // MARK: - Buttons & Controls
    @IBAction func bullseyeSarDotButton(_ sender: UIButton) {
        if sender.currentTitle == "BE" {
            beOrSardotButtonOutlet.setTitle("SD", for: .normal)
            beOrSd = "SD"
        } else {
            beOrSardotButtonOutlet.setTitle("BE", for: .normal)
            beOrSd = "BE"
        }
        beOrSd = sender.currentTitle!
    }
    // MARK: Text Fields
    @IBAction func BullseyeNameTextField(_ sender: UITextField) {
        nameBE = sender.text!
    }
    
    @IBAction func coordsTextfield(_ sender: UITextField) {
        coordString = coordsTextFieldOutlet.text ?? ""
        print(coordString)
    }
    @IBOutlet weak var coordInfoButton: UIButton!
    
    //MARK: PickerView
    let lineWidthArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12", "13", "15", "16", "17", "18", "19", "20", ]
    let sizeOfBullseyeArray = ["100", "120", "140", "160", "180", "200", "220", "240", "260", "280", "300"]
    var bullsEyeColorArray = ["Black", "Red", "Orange", "LightYellow", "DarkGreen", "Blue"]
    var centerIconTypeArray = ["forbidden", "blueCircleCircle", "blueCircleDiamond", "blueCircleSquare", "lightBlueCircleCircle", "lightBlueCircleDiamond", "lightBlueCircleSquare", "pinkCircleCircle", "pinkCircleDiamond", "pinkCircleSquare", "purpleCircleCircle", "purpleCircleDiamond", "purpleCircleSquare", "redCircleCircle", "redCircleDiamond", "redCircleSquare", "yellowCircleCircle", "yellowCircleDiamond", "yellowCircleSquare", "whiteCircleCircle", "whiteCircleDiamond", "whiteCircleSquare"]
    var rangeBearingIconTypeArray = ["bluePin", "greenPin", "lightBluePin","pinkPin","purplePin", "yellowPin", "whitePin"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return bullsEyeColorArray.count
        } else if component == 1 {
            return lineWidthArray.count
        } else if component == 2 {
            return sizeOfBullseyeArray.count
        } else if component == 3 {
            return centerIconTypeArray.count
        } else {
            return rangeBearingIconTypeArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if let lineColorBE_ = ColorKML(rawValue: bullsEyeColorArray[row].switchColorImageToCode()) {
                lineColorBE = lineColorBE_
            }
        } else if component == 1 {
            lineWidth = lineWidthArray[row]
        } else if component == 2 {
            sizeBE = sizeOfBullseyeArray[row]
        } else if component == 3 {
            print(centerIconTypeArray[row])
            if let centerpointIconBE_ = IconType(rawValue: centerIconTypeArray[row].switchIconImageNameToHref()) {
                centerpointIconBE = centerpointIconBE_
            }
        } else {
            if let rangeBearingIconBE_ = IconType(rawValue: rangeBearingIconTypeArray[row].switchIconImageNameToHref()) {
                rangeBearingIconBE = rangeBearingIconBE_
            }
        }
    }
 
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        if component == 0 {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: bullsEyeColorArray[row]))
            return myImageView
        } else if component == 1 {
            let widthList = UILabel()
            widthList.textAlignment = .center
            widthList.text = lineWidthArray[row]
            widthList.font = UIFont.boldSystemFont(ofSize: 22)
            return widthList
        } else if component == 2 {
            let sizeList = UILabel()
            sizeList.textAlignment = .center
            sizeList.text = sizeOfBullseyeArray[row]
            sizeList.font = UIFont.boldSystemFont(ofSize: 22)
            return sizeList
        } else if component == 3 {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: centerIconTypeArray[row]))
            return myImageView
        } else {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: rangeBearingIconTypeArray[row]))
            return myImageView
        }
    }
 
    //MARK: Mag Variation
    @IBAction func magVariationStepper(_ sender: UIStepper) {
        magVarBE = sender.value
    }
    @IBAction func magVariationCurrentPositionButton(_ sender: UIButton) {
        currentMagVarLocOutlet.showPressed()
        if positionAvailable == true {
            magVarBE = currentMagVar
        }}
    
    //Label Controls
    @IBAction func centerPointLabelSwitch(_ sender: UISwitch) {
        if sender.isOn {
            centerpointLabelBE = true
        } else {
            centerpointLabelBE = false
        }}
    @IBAction func rangeLabelSwitch(_ sender: UISwitch) {
        if sender.isOn {
            rangeLabelBE = true
        } else {
            rangeLabelBE = false
        }}
    @IBAction func bearingLabelSwitch(_ sender: UISwitch) {
        if sender.isOn {
            bearingLabelBE = true
        } else {
            bearingLabelBE = false
        }}
    @IBAction func centerpointIconSwitch(_ sender: UISwitch) {
        if sender.isOn {
            centerpointIconIncludedBE = true
        } else {
            centerpointIconIncludedBE = false
        }}
    @IBAction func rangeBearingIconsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            rangeBearingIconsIncludedBE = true
        } else {
            rangeBearingIconsIncludedBE = false
        }}
    @IBAction func includedInBLKMLSwitch(_ sender: UISwitch) {
        if sender.isOn {
            includedInBlBE = true
        } else {
            includedInBlBE = false
        }}
    

    //MARK: Bottom Buttons
    @IBAction func clearAllInputButton(_ sender: UIButton) {
        clearAllInputButtonOutlet.showPressed()
        clearInformation()
        let alertController = UIAlertController(title: "Delete All BE/Sar/DOTs?", message:
            "Are you sure you want to delete all stored Bullseyes and SAR/DOT.", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Hmmm... maybe not.", style: UIAlertAction.Style.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "I'm not scared!", style: .destructive, handler: { _ in
            self.cdu.deleteAllBEandSARDOTFromDB(pc: self.pc)
        }))
        self.present(alertController, animated: true)
    }
    @IBAction func saveBullseyeButton(_ sender: UIButton) {
        if validateTextFields() == false { return } else {
            print("******************************************************")
            print("Latitude: \(centerPointLatitudeDouble) Longitude: \(centerPointLongitudeDouble)")
            print("******************************************************")
            cdu.setBullseye(bearingIconsIncluded: rangeBearingIconsIncludedBE,
                            bearingLabels: bearingLabelBE,
                            bullsEyeName: nameBE,
                            centerPoint: [centerPointLatitudeDouble, centerPointLongitudeDouble],
                            centerpointIcon: centerpointIconBE.rawValue,
                            centerpointIconIncluded: centerpointIconIncludedBE,
                            centerpointLabel: centerpointLabelBE,
                            lineColor: lineColorBE.rawValue,
                            lineOpacity: lineOpacityBE.rawValue,
                            lineThickness: Int16(lineWidth) ?? 5,
                            magVariation: magVarBE,
                            polyColor: polyColorBE.rawValue,
                            polyOpacity: polyOpacityBE.rawValue,
                            radiusOfOuterRing: sizeDoubleBE,
                            rangeBearingIconType: rangeBearingIconBE.rawValue,
                            rangeIconsIncluded: rangeBearingIconsIncludedBE,
                            rangeLabels: rangeLabelBE,
                            includedInBL: includedInBlBE,
                            itIsABullseye: isItABullseye,
                            pc: pc)
            saveBullseyeButtonOutlet.showPressed()
        }
        
    }
//    @IBAction func exportToForeFlightButton(_ sender: UIButton) {
//    }
    
    
    
    
    // MARK: - Functions
    func generateKml() -> String {
        var kml = ""
        var internalKML = ""
        let bullsEyeContainer = cdu.getBullseye(pc: pc)
        let sarDotContainer = cdu.getSarDot(pc: pc)
        for be in bullsEyeContainer {
            let centerpointAdjusted = [be.centerPoint_CD![1], be.centerPoint_CD![0]]
            internalKML += BullsEyeKML(bullsEyeName: be.bullsEyeName_CD!,
                                 centerPoint: centerpointAdjusted,
                                 radiusOfOuterRing: Double(be.radiusOfOuterRing_CD),
                                 magVariation: be.magVariation_CD,
                                 lineColor: ColorKML(rawValue: be.lineColor_CD!)!,
                                 centerpointLabel: be.centerpointLabel_CD,
                                 rangeLabels: be.rangeLabels_CD,
                                 bearingLabels: be.bearingLabels_CD,
                                 centerpointIcon: IconType(rawValue: be.centerpointIcon_CD!)!,
                                 rangeBearingIconType: IconType(rawValue: be.rangeBearingIconType_CD!)!,
                                 centerpointIconIncluded: be.centerpointIconIncluded_CD,
                                 rangeIconsIncluded: be.rangeIconsIncluded_CD,
                                 bearingIconsIncluded: be.bearingIconsIncluded_CD).BEKmlGenerator()
        }
        for sd in sarDotContainer {
            let centerpointAdjusted = [sd.centerPoint_CD![1], sd.centerPoint_CD![0]]
            internalKML += BullsEyeKML(bullsEyeName: sd.bullsEyeName_CD!,
                                       centerPoint: centerpointAdjusted,
                                       radiusOfOuterRing: Double(sd.radiusOfOuterRing_CD),
                                       magVariation: sd.magVariation_CD,
                                       lineColor: ColorKML(rawValue: sd.lineColor_CD!)!,
                                       centerpointLabel: sd.centerpointLabel_CD,
                                       rangeLabels: sd.rangeLabels_CD,
                                       bearingLabels: sd.bearingLabels_CD,
                                       centerpointIcon: IconType(rawValue: sd.centerpointIcon_CD!)!,
                                       rangeBearingIconType: IconType(rawValue: sd.rangeBearingIconType_CD!)!,
                                       centerpointIconIncluded: sd.centerpointIconIncluded_CD,
                                       rangeIconsIncluded: sd.rangeIconsIncluded_CD,
                                       bearingIconsIncluded: sd.bearingIconsIncluded_CD).BEKmlGenerator()
        }
        kml = OpenCloseKML(kmlItems: internalKML).KMLGenerator()
        return kml
    }
    
    @IBAction func exportToForeFlightButton(_ sender: UIButton) {
        self.passToShareSheetWithfileNamePopupWith(placeHolder: "BE_SD", ext: "kml", stingToWrite: generateKml())
    }
    
    
    func coordValidationTextfieldFormatting(valid: Bool) {
        if valid == true {
            coordsTextFieldOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            coordsTextFieldOutlet.layer.borderWidth = 1
        } else {
            coordsTextFieldOutlet.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            coordsTextFieldOutlet.layer.borderWidth = 1
        }}
    
    var chosenBE: BullseyeCD?
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let source = segue.source as? BullseyeTableViewController
        chosenBE = (source?.chosenBE_SARDOT)
        if let be_CD = chosenBE {
            let centerpointAdjusted = [be_CD.centerPoint_CD![1], be_CD.centerPoint_CD![0]]
            // TODO: Add in controls for user interface
            let be = BullsEyeKML(bullsEyeName: be_CD.bullsEyeName_CD!,
                                  centerPoint: centerpointAdjusted,
                                  radiusOfOuterRing: Double(be_CD.radiusOfOuterRing_CD),
                                  magVariation: be_CD.magVariation_CD,
                                  lineColor: ColorKML(rawValue: be_CD.lineColor_CD!)!,
                                  centerpointLabel: be_CD.centerpointLabel_CD,
                                  rangeLabels: be_CD.rangeLabels_CD,
                                  bearingLabels: be_CD.bearingLabels_CD,
                                  centerpointIcon: IconType(rawValue: be_CD.centerpointIcon_CD!)!,
                                  rangeBearingIconType: IconType(rawValue: be_CD.rangeBearingIconType_CD!)!,
                                  centerpointIconIncluded: be_CD.centerpointIconIncluded_CD,
                                  rangeIconsIncluded: be_CD.rangeIconsIncluded_CD,
                                  bearingIconsIncluded: be_CD.bearingIconsIncluded_CD).BEKmlGenerator()
            if let fileName_ = be_CD.bullsEyeName_CD {
                let fileName = fileName_
                let ext = "kml"
                let kml = OpenCloseKML(kmlItems: be).KMLGenerator()
                self.exportToForeFlight = [fileName, ext, kml]
            }}
    }

    func getpositionPermission(){
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        locManager.distanceFilter = kCLDistanceFilterNone
        locManager.headingFilter = kCLHeadingFilterNone
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.headingOrientation = .portrait
        locManager.delegate = self
        locManager.startUpdatingHeading()
        locManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentMagVar = newHeading.trueHeading - newHeading.magneticHeading
        positionAvailable = true
    }
    
    func isLoactionAvailable() {
        if locManager.location != nil {
            positionAvailable = true
        } else {
            positionAvailable = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == bullseyeNameTextfield {
            coordsTextFieldOutlet.becomeFirstResponder()
        } else if textField == coordsTextFieldOutlet {
            textField.resignFirstResponder()
        }
        return true
    }
    func clearInformation() {
        beOrSd = "BE"
        beOrSardotButtonOutlet.setTitle("BE", for: .normal)
        nameBE = ""
        bullseyeNameTextfield.text = ""
        coordsTextFieldOutlet.text = ""
        sizeBE = "---"
        centerpointLabelBE = true
        rangeLabelBE = true
        bearingLabelBE = true
        centerpointIconIncludedBE = true
        rangeBearingIconsIncludedBE = true
        includedInBlBE = true
    }
    func setFrameFormatting(outletArray: [UIView]) {
        for v in outletArray {
            v.layer.borderWidth = 1
            v.layer.borderColor = #colorLiteral(red: 0.1494517922, green: 0.1863500476, blue: 0.2364396751, alpha: 1)
            v.layer.cornerRadius = 5
        }
    }
    func setButtonFormatting(buttonArray: [UIButton]) {
        for button in buttonArray {
            button.standardButtonFormatting(cornerRadius: false)
        }
        currentMagVarLocOutlet.layer.cornerRadius = 17.5
        let barAlpha = CGFloat(0.0)
        let barColor = UIColor.clear
        titleBackbroundBlurTop.backgroundColor = barColor
        titleBackbroundBlurTop.alpha = barAlpha
        titleBackbroundBlurBottom.backgroundColor = barColor
        titleBackbroundBlurBottom.alpha = barAlpha
        tiltleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        beOrSardotButtonOutlet.layer.cornerRadius = 10
        magVarStepperOutlet.layer.cornerRadius = 10
        centerpointSwitchOutlet.onTintColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        rangeSwitchOutlet.onTintColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        bearingSwitchOutlet.onTintColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        centerpointIconSwitchOutlet.onTintColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        rangeBearingIconsSwitchOutlet.onTintColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        includedInBLKMLSwitchOutlet.onTintColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        clearAllInputButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.1549932063, blue: 0, alpha: 1)
        clearAllInputButtonOutlet.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        saveBullseyeButtonOutlet.showPressed()
        
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let cornerRadius: CGFloat = 5
        clearAllInputButtonOutlet.layer.borderColor = borderColor
        clearAllInputButtonOutlet.layer.borderWidth = borderWidth
        clearAllInputButtonOutlet.layer.cornerRadius = cornerRadius
        saveBullseyeButtonOutlet.layer.borderColor = borderColor
        saveBullseyeButtonOutlet.layer.borderWidth = borderWidth
        saveBullseyeButtonOutlet.layer.cornerRadius = cornerRadius
    }

    // MARK: - Seque Control
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "bullseyeTable"?:
            let bullseyeArray = cdu.getBullseye(pc: pc)
            let sarDotArray = cdu.getSarDot(pc: pc)
            let destinationViewController = segue.destination as! BullseyeTableViewController
            destinationViewController.bullsEyeArray = bullseyeArray
            destinationViewController.sarDotArray = sarDotArray
            destinationViewController.beOrSd = beOrSd
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = CGRect(x: 0, y: 0, width: sourceView.frame.width/2, height: sourceView.frame.height)
                popoverPresentationController.backgroundColor = UIColor.clear
            }
        case "coordInfoPopupSegueBE"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
}
