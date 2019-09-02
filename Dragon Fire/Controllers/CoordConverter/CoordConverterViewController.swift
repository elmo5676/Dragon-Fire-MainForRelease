//
//  CoordConverterViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 8/5/18.
//  Copyright © 2018 elmo. All rights reserved.
//
//                ␣⬅︎
//    var latLong = "28°32.56N / 122°32.32W"
//    var utm = "10N 543221 3153595"
//    var mgrs = "10R ES 43220 53594"

import UIKit

class CoordConverterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        setFormatting()
        coordType = .latLong
        setSelectedCoordTypeButtonFormatInitial()
        inputOutputLabelFormattingReset()
        latLongInputFormat = .DDMMSS
    }
    override func viewWillDisappear(_ animated: Bool) {
        setFormatting()
        coordType = .latLong
        setSelectedCoordTypeButtonFormatInitial()
        inputOutputLabelFormattingReset()
        latLongInputFormat = .DDMMSS
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    // MARK: - Initial Variables
    var latLongInputFormat: LatLonFormat = .DDMMSS {
        didSet {
            clear()
            for item in latLonOptionButtonOutletCollection {
                setSelectedOptionButtonFormat(selectedButton: item)
    }}}
    
    var utmPrefix = ""
    var mgrsPrefix = ""
    var clearPrefix: Bool = false {
        didSet {
            switch clearPrefix {
            case true:
                print(clearPrefix)
            case false:
                print(clearPrefix)
            }
        }
    }
    
    
    var coordType: CoordType = .latLong {
        didSet {
            hideOptions(coordType: coordType)
            switch coordType{
            case .latLong:
                clear()
                inputToResultConstant.constant = 60
                coordIndicatorLabel_01.text = "LAT/LONG"
                coordIndicatorLabel_02.text = "UTM"
                coordIndicatorLabel_03.text = "MGRS"
            case .utm:
                clear()
                inputToResultConstant.constant = 10
                coordIndicatorLabel_01.text = "UTM"
                coordIndicatorLabel_02.text = "LAT/LONG"
                coordIndicatorLabel_03.text = "MGRS"
            case .mgrs:
                clear()
                inputToResultConstant.constant = 10
                coordIndicatorLabel_01.text = "MGRS"
                coordIndicatorLabel_02.text = "UTM"
                coordIndicatorLabel_03.text = "LAT/LONG"
    }}}
    
    var inputField: String = "" {
        didSet {
            if inputField == "" {numberPadEnabled(true)}
            switch coordType {
            case .latLong:
                switch latLongInputFormat {
                case .DDMMSS:
                    inputField = latLongInputFormatter_DDMMSS(input: inputField)
                case .DDMMdd:
                    inputField = latLongInputFormatter_DDMMdd(input: inputField)
                case .DDdddd:
                    inputField = latLongInputFormatter_DDdddd(input: inputField)
                }
                coordInputLabel.text = inputField
                print(coordType)
            case .utm:
                inputField = utmInputFormatter(input: inputField)
                coordInputLabel.text = inputField
                print(coordType)
            case .mgrs:
                inputField = mgrsInputFormatter(input: inputField)
                coordInputLabel.text = inputField
                print(coordType)
    }}}
    
    var validCoords: Bool = false {
        didSet {
            switch coordType{
            case .latLong:
                if validCoords == true {
                    displayMGRSandUTMfromLatLong(latLong: inputField)
                    displayOtherLatLongFormats(inputFormat: latLongInputFormat, coords: inputField)
                    print(inputField)
                } else {
                    clearResults()
                }
            case .utm:
                if validCoords == true {
                    displayLatLonAndMGRSfromUTM(utm: inputField)
                    print(inputField)
                } else {
                    clearResults()
                }
            case .mgrs:
                if validCoords == true {
                    displayLatLonAndUTMfromMGRS(mgrs: inputField)
                    print(inputField)
                } else {
                    clearResults()
    }}}}
    
    // MARK: - Enums
    enum CoordType {
        case latLong
        case utm
        case mgrs
    }
    
    enum LatLonFormat {
        case DDMMSS
        case DDMMdd
        case DDdddd
    }
    
    // MARK: - Outlets
    //outletCollections
    @IBOutlet var labelOutletCollection: [UILabel]!
    @IBOutlet var coordTypButtonOutletCollection: [UIButton]!
    @IBOutlet var latLonOptionButtonOutletCollection: [UIButton]!
    @IBOutlet var mainViewOutletCollection: [UIView]!
    @IBOutlet var letterPadOutletCollection: [UIButton]!
    @IBOutlet var numberPadOutletCollection: [UIButton]!
    @IBOutlet var shareButtons: [UIButton]!
    @IBOutlet weak var shareTopButtonOutlet: UIButton!
    @IBOutlet weak var shareBottomButtonOutlet: UIButton!
    
    //coordType label indicators
    @IBOutlet weak var coordIndicatorLabel_01: UILabel!
    @IBOutlet weak var otherLatLonFormatLabel: UILabel!
    @IBOutlet weak var coordIndicatorLabel_02: UILabel!
    @IBOutlet weak var coordIndicatorLabel_03: UILabel!
    @IBOutlet weak var coordInputLabel: UILabel!
    @IBOutlet weak var coordResultLabel_01: UILabel!
    @IBOutlet weak var coordResultLabel_02: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var inputToResultConstant: NSLayoutConstraint!
    @IBOutlet weak var clearPrefixLabel: UILabel!
    
    
    // MARK: - Buttons and Controls
    var coordsToShare: String = ""
    @IBAction func shareTopButton(_ sender: UIButton) {
        shareTopButtonOutlet.showPressed()
        if let coords = coordResultLabel_01.text {
            coordsToShare = coords.removeSpaces()
            UIPasteboard.general.string = coords.removeSpaces()
            print(coords.removeSpaces())
            performSegue(withIdentifier: "shareCoordsSegue", sender: nil)
            coordsToShare = ""
        }
    }
    
    @IBAction func shareBottomButton(_ sender: UIButton) {
        shareBottomButtonOutlet.showPressed()
        if let coords = coordResultLabel_02.text {
            coordsToShare = coords.removeSpaces()
            UIPasteboard.general.string = coords.removeSpaces()
            print(coords.removeSpaces())
            performSegue(withIdentifier: "shareCoordsSegue", sender: nil)
            coordsToShare = ""
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "shareCoordsSegue"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController {
                let sizePop = CGRect(x: 0, y: 0, width: 106, height: 54)
                popoverPresentationController.sourceRect = sizePop  //sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
            let destinationViewController = segue.destination as! CoorShareViewController
            destinationViewController.coordsToShare = coordsToShare
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
    @IBAction func coordTypeSelectedButton(_ sender: UIButton) {
        switch sender.currentTitle {
        case "LAT/LONG":
            coordType = .latLong
        case "UTM":
            coordType = .utm
        case "MGRS":
            coordType = .mgrs
        default:
            print("Unable to determin coordType")
        }
        setSelectedCoordTypeButtonFormat(selectedButton: sender)
    }
    
    @IBAction func optionSelectedButton(_ sender: UIButton) {
        switch sender.currentTitle {
        case "DD°MM°SSN /DDD°MM°SSW":
            latLongInputFormat = .DDMMSS
        case "DD°MM.ddN / DDD°MM.ddW":
            latLongInputFormat = .DDMMdd
        case "DD.ddddN / DDD.ddddW":
            latLongInputFormat = .DDdddd
        default:
            print("Unable to determin coordType")
        }
        setSelectedOptionButtonFormat(selectedButton: sender)
    }
    
    @IBAction func numberButton(_ sender: UIButton) {
        for item in numberPadOutletCollection {
            if item.currentTitle == sender.currentTitle && sender.currentTitle != "⬅︎" {
                item.showPressed()
            } else if item.currentTitle == sender.currentTitle && sender.currentTitle == "⬅︎"{
                item.showPressedDark()
            }}
        switch sender.currentTitle {
        case "C":
            clear()
            numberPadEnabled(true)
        case "␣":
            inputField += " "
        case "⬅︎":
            // TODO: get user location
            backSpace(input: inputField)
        default:
            inputField += sender.currentTitle!
    }}
    
    @IBAction func letterButton(_ sender: UIButton) {
        for item in letterPadOutletCollection {
            if item.currentTitle == sender.currentTitle {
                item.showPressed()
            }}
        inputField += sender.currentTitle!
    }
    
    @IBOutlet weak var latLongButtonOutlet: UIButton!
    
    // MARK: - Functions
    func clear() {
        inputField = ""
        coordResultLabel_01.text = ""
        coordResultLabel_02.text = ""
        inputOutputLabelFormattingReset()
        otherLatLonFormatLabel.text = ""
    }
    
    func clearResults() {
        coordResultLabel_01.text = ""
        coordResultLabel_02.text = ""
        inputOutputLabelFormattingReset()
        otherLatLonFormatLabel.text = ""
    }
    
    func backSpace(input: String) {
        switch input.last {
        case ".":
            inputField = String(input.dropLast(2))
        case "°":
            inputField = String(input.dropLast(2))
        case " ":
            inputField = String(input.dropLast(2))
        case ",":
            inputField = String(input.dropLast(2))
        default:
            inputField = String(input.dropLast())
    }}
    
    func numberPadEnabled(_ enabled: Bool) {
        for item in numberPadOutletCollection {
            if item.currentTitle != "C" {
                if item.currentTitle != "⬅︎" {
                    if enabled == true {
                        item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
                    } else {
                        item.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    }
                    item.isEnabled = enabled
    }}}}
    
    func displayMGRSandUTMfromLatLong(latLong: String) {
        do {
            let latLon = try LatLon.parseLatLon(stringToParse: latLong)
            let utm = try latLon.toUTM()
            let mgrs = try utm.toMGRS()
            coordResultLabel_01.text = utm.toString(precision: 5)
            coordResultLabel_02.text = mgrs.toString(precision: 5)
        } catch {
            displayErrorStringwithFormating("Invalid Entry")
            print(error)
    }}
    
    func displayOtherLatLongFormats(inputFormat: LatLonFormat, coords: String) {
        do {
            let latLon = try LatLon.parseLatLon(stringToParse: coords)
            let DDMMSS = latLon.toString(format: .degreesMinutesSeconds, decimalPlaces: 0)
            let DDMMdd = latLon.toString(format: .degreesMinutes, decimalPlaces: 2)
            let DDdddd = latLon.toString(format: .degrees, decimalPlaces: 4)
            otherLatLonFormatLabel.setFont(name: .Avenir, size: 15, color: #colorLiteral(red: 0.9490196078, green: 0.9960784314, blue: 0.7019607843, alpha: 1))
            switch inputFormat {
            case .DDMMSS:
                otherLatLonFormatLabel.text = "\(DDMMdd)        \(DDdddd)"
            case .DDMMdd:
                otherLatLonFormatLabel.text = "\(DDMMSS)        \(DDdddd)"
            case .DDdddd:
                otherLatLonFormatLabel.text = "\(DDMMSS)        \(DDMMdd)"
            }
        } catch {
            print(error)
    }}
    
    func displayLatLonAndUTMfromMGRS(mgrs: String) {
        do {
            let mgrs = try Mgrs.parse(fromString: mgrs)
            let utm = try mgrs.toUTM()
            let latLon = utm.toLatLonE()
            coordResultLabel_01.text = utm.toString(precision: 5)
            coordResultLabel_02.text = latLon.toString(format: .degreesMinutes, decimalPlaces: 2)
        } catch {
            displayErrorStringwithFormating("Invalid Entry")
            print(error)
    }}
    
    func displayLatLonAndMGRSfromUTM(utm: String) {
        do {
            let utm = try Utm.parseUTM(utmCoord: utm)
            let mgrs = try utm.toMGRS()
            let latLon = utm.toLatLonE()
            coordResultLabel_01.text = latLon.toString(format: .degreesMinutes, decimalPlaces: 2)
            coordResultLabel_02.text = mgrs.toString(precision: 5)
        } catch {
            displayErrorStringwithFormating("Invalid Entry")
            print(error)
    }}
    
    func displayErrorStringwithFormating(_ string: String) {
        coordResultLabel_02.setFont(name: .systemFont, size: 25, color: #colorLiteral(red: 0.2980392157, green: 0.4196078431, blue: 0.6862745098, alpha: 1))
        coordResultLabel_02.text = "\(string)"
    }
    
    func inputOutputLabelFormattingReset() {
        coordInputLabel.setFont(name: .systemFont, size: 40, color: #colorLiteral(red: 0.9490196078, green: 0.9960784314, blue: 0.7019607843, alpha: 1))
        coordResultLabel_01.setFont(name: .systemFont, size: 40, color: #colorLiteral(red: 0.9490196078, green: 0.9960784314, blue: 0.7019607843, alpha: 1))
        coordResultLabel_02.setFont(name: .systemFont, size: 40, color: #colorLiteral(red: 0.9490196078, green: 0.9960784314, blue: 0.7019607843, alpha: 1))
    }
    
    func setFormatting() {
        let cornerRadius: CGFloat = 5
        let borderWidth: CGFloat = 1
        latLongButtonOutlet.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        latLongButtonOutlet.layer.borderWidth = borderWidth
        for item in labelOutletCollection {
            item.layer.cornerRadius = cornerRadius
        }
        for item in coordTypButtonOutletCollection {
            item.layer.cornerRadius = cornerRadius
        }
        for item in latLonOptionButtonOutletCollection {
            item.layer.cornerRadius = cornerRadius
        }
        for item in letterPadOutletCollection {
            item.layer.cornerRadius = cornerRadius
            item.layer.borderWidth = borderWidth
        }
        for item in numberPadOutletCollection {
            item.layer.cornerRadius = cornerRadius
            item.layer.borderWidth = borderWidth
        }
        for item in mainViewOutletCollection {
            item.layer.cornerRadius = cornerRadius
            item.layer.borderColor = #colorLiteral(red: 0.1777316034, green: 0.1766818762, blue: 0.1785428226, alpha: 1)
            item.layer.borderWidth = borderWidth
    }}
    
    func comingSoon() {
        coordResultLabel_01.text = "Coming Soon"
        coordResultLabel_02.text = "Coming Soon"
        letterButtonsDisabled(true)
        numberPadEnabled(false)
    }
    
    func setSelectedCoordTypeButtonFormat(selectedButton: UIButton) {
        for item in coordTypButtonOutletCollection {
            if selectedButton.currentTitle == item.currentTitle {
                item.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.2705882353, blue: 0.09803921569, alpha: 1)
                item.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                item.layer.borderWidth = 1
                item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                item.backgroundColor = #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 1)
                item.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                item.layer.borderWidth = 0
                item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }}}
    
    func setSelectedCoordTypeButtonFormatInitial() {
        for item in coordTypButtonOutletCollection {
            switch coordType {
            case .latLong:
                if item.currentTitle == "LAT/LONG" {
                    item.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.2705882353, blue: 0.09803921569, alpha: 1)
                    item.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                    item.layer.borderWidth = 1
                    item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    item.backgroundColor = #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 1)
                    item.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    item.layer.borderWidth = 0
                    item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            case .utm:
                if item.currentTitle == "UTM" {
                    item.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.2705882353, blue: 0.09803921569, alpha: 1)
                    item.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                    item.layer.borderWidth = 1
                    item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    item.backgroundColor = #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 1)
                    item.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    item.layer.borderWidth = 0
                    item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            case .mgrs:
                if item.currentTitle == "MGRS" {
                    item.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.2705882353, blue: 0.09803921569, alpha: 1)
                    item.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                    item.layer.borderWidth = 1
                    item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    item.backgroundColor = #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 1)
                    item.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    item.layer.borderWidth = 0
                    item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }}}}
    
    func setSelectedOptionButtonFormat(selectedButton: UIButton) {
        for item in latLonOptionButtonOutletCollection {
            if selectedButton.currentTitle == item.currentTitle {
                item.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.2705882353, blue: 0.09803921569, alpha: 1)
                item.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                item.layer.borderWidth = 1
                item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                item.backgroundColor = #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 1)
                item.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                item.layer.borderWidth = 0
                item.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }}}
    
    func latLongAvailableOnly(lat: Bool, long: Bool) {
        if lat == true {
            for item in letterPadOutletCollection {
                switch item.currentTitle {
                case "N":
                    item.isEnabled = true
                    item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
                case "S":
                    item.isEnabled = true
                    item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
                default:
                    item.isEnabled = false
                    item.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }}}
        if long == true {
            for item in letterPadOutletCollection {
                switch item.currentTitle {
                case "W":
                    item.isEnabled = true
                    item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
                case "E":
                    item.isEnabled = true
                    item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
                default:
                    item.isEnabled = false
                    item.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }}}
        if lat == false && long == false {
            for item in letterPadOutletCollection {
                item.isEnabled = true
                item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
    }}}
    
    func letterButtonsDisabled(_ da: Bool) {
        if da {
            for item in letterPadOutletCollection {
                item.isEnabled = false
                item.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }}
        if da == false {
            for item in letterPadOutletCollection {
                item.isEnabled = true
                item.backgroundColor = #colorLiteral(red: 0, green: 0.03529411765, blue: 0.6, alpha: 1)
    }}}
    
    func hideOptions(coordType: CoordType) {
        switch coordType {
        case .latLong:
            optionsView.isHidden = false
        case .utm:
            optionsView.isHidden = true
            
        case .mgrs:
            optionsView.isHidden = true
        }}
    
    // MARK: - InputFormatting
    func utmInputFormatter(input: String) -> String {
        //    var utm = "10N 543221 315359"
        var output = ""
        validCoords = false
        switch input.count {
        case 0:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 1:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 2:
            letterButtonsDisabled(false)
            numberPadEnabled(false)
            output = "\(input) "
            validCoords = false
        case 3:
            letterButtonsDisabled(false)
            numberPadEnabled(false)
            output = input
            validCoords = false
        case 4:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input) "
            validCoords = false
        case 5:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 6:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 7:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 8:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 9:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 10:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 11:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input) "
            validCoords = false
        case 12:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 13:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 14:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 15:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 16:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 17:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 18:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = true
        default:
            print(output)
        }
        return output
    }
    
    func mgrsInputFormatter(input: String) -> String {
        var output = ""
        validCoords = false
        switch input.count {
        case 0:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 1:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 2:
            letterButtonsDisabled(false)
            numberPadEnabled(false)
            output = input
            validCoords = false
        case 3:
            letterButtonsDisabled(false)
            numberPadEnabled(false)
            output = "\(input) "
            validCoords = false
        case 4:
            letterButtonsDisabled(false)
            numberPadEnabled(false)
            output = input
            validCoords = false
        case 5:
            letterButtonsDisabled(false)
            numberPadEnabled(false)
            output = input
            validCoords = false
        case 6:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input) "
            validCoords = false
        case 7:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 8:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 9:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 10:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 11:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 12:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input) "
            validCoords = false
        case 13:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 14:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 15:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 16:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 17:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 18:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = true
        default:
            print(output)
        }
        
        return output
    }
    func latLongInputFormatter_DDMMSS(input: String) -> String {
        var output = ""
        validCoords = false
        switch input.count {
        case 0:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 1:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 2:
            letterButtonsDisabled(true)
            output = "\(input)°"
            validCoords = false
        case 3:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 4:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 5:
            letterButtonsDisabled(true)
            output = "\(input)'"
            validCoords = false
        case 6:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 7:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
            numberPadEnabled(true)
        case 8:
            latLongAvailableOnly(lat: true, long: false)
            output = input
            validCoords = false
            numberPadEnabled(false)
        case 9:
            letterButtonsDisabled(true)
            output = "\(input) / "
            validCoords = false
            numberPadEnabled(true)
        case 11:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 15:
            letterButtonsDisabled(true)
            output = "\(input)°"
            validCoords = false
        case 16:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 18:
            letterButtonsDisabled(true)
            output = "\(input)'"
            validCoords = false
        case 19:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 20:
            letterButtonsDisabled(true)
            output = input
            numberPadEnabled(true)
        case 21:
            latLongAvailableOnly(lat: false, long: true)
            output = input
            validCoords = false
            numberPadEnabled(false)
        case 22:
            output = input
            latLongAvailableOnly(lat: false, long: false)
            validCoords = true
        default:
            output = input
            print(output)
        }
        return output
    }
    func latLongInputFormatter_DDMMdd(input: String) -> String {
        var output = ""
        validCoords = false
        switch input.count {
        case 0:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 1:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 2:
            letterButtonsDisabled(true)
            output = "\(input)°"
            validCoords = false
        case 3:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 5:
            letterButtonsDisabled(true)
            output = "\(input)."
            validCoords = false
        case 6:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 7:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
            numberPadEnabled(true)
        case 8:
            latLongAvailableOnly(lat: true, long: false)
            output = input
            validCoords = false
            numberPadEnabled(false)
        case 9:
            letterButtonsDisabled(true)
            output = "\(input) / "
            validCoords = false
            numberPadEnabled(true)
        case 11:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 15:
            letterButtonsDisabled(true)
            output = "\(input)°"
            validCoords = false
        case 16:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 18:
            letterButtonsDisabled(true)
            output = "\(input)."
            validCoords = false
        case 19:
            letterButtonsDisabled(true)
            output = input
            validCoords = false
        case 20:
            letterButtonsDisabled(true)
            output = input
            numberPadEnabled(true)
        case 21:
            latLongAvailableOnly(lat: false, long: true)
            output = input
            validCoords = false
            numberPadEnabled(false)
        case 22:
            output = input
            latLongAvailableOnly(lat: false, long: false)
            validCoords = true
        default:
            output = input
            print(output)
        }
        return output
    }
    func latLongInputFormatter_DDdddd(input: String) -> String {
        var output = ""
        validCoords = false
        switch input.count {
        case 0:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 1:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 2:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input)."
            validCoords = false
        case 3:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 4:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 5:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 6:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = input
            validCoords = false
        case 7:
            latLongAvailableOnly(lat: true, long: false)
            output = "\(input)°"
            validCoords = false
            numberPadEnabled(false)
        case 8:
            output = input
            validCoords = false
        case 9:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input) / "
            validCoords = false
        case 10:
            output = input
            validCoords = false
        case 11:
            output = input
            validCoords = false
        case 15:
            letterButtonsDisabled(true)
            numberPadEnabled(true)
            output = "\(input)."
            validCoords = false
        case 20:
            latLongAvailableOnly(lat: false, long: true)
            output = input
            validCoords = false
            numberPadEnabled(false)
        case 21:
            output = input
            latLongAvailableOnly(lat: false, long: false)
            validCoords = true
        default:
            output = input
            validCoords = false
        }
        print(input.count)
        print(output.count)
        return output
    }
    
    
    
    
    
    
    
    
    
    
}

//    switch input.count {
//    case 0:
//    print("")
//    case 1:
//    print("")
//    case 2:
//    print("")
//    case 3:
//    print("")
//    case 4:
//    print("")
//    case 5:
//    print("")
//    case 6:
//    print("")
//    case 7:
//    print("")
//    case 8:
//    print("")
//    case 9:
//    print("")
//    case 10:
//    print("")
//    case 11:
//    print("")
//    case 12:
//    print("")
//    case 13:
//    print("")
//    case 14:
//    print("")
//    case 15:
//    print("")
//    case 16:
//    print("")
//    case 17:
//    print("")
//    case 18:
//    print("")
//    case 19:
//    print("")
//    case 20:
//    print("")
//    case 21:
//    print("")
//    case 22:
//    print("")
//    case 23:
//    print("")
//    }






























