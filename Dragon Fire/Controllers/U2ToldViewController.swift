//
//  ToldViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 8/4/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class U2ToldViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFormating()
        initialPickerViewLoad(fuelLoad: getDefaults().fuelLoad,
                              ktJet: getDefaults().ktJet,
                              condition: getDefaults().condition,
                              tempF: getDefaults().tempInF,
                              fieldElev: getDefaults().fieldElev,
                              windSpeed: getDefaults().windSpeed,
                              windDir: getDefaults().windDirection,
                              rwyHdg: getDefaults().rwyHdg,
                              flaps15: getDefaults().flaps15,
                              spoilers: getDefaults().spoilers)
        calculateTold()
        calculateGlideNumber()
    }

    // MARK: - Initial Setup
    let configurationArray = ["Slick","Pods","Peg & Pods"]
    let correctionsArray = ["None","Gust Up","Speed Brake","Spoilers", "Speed Brake & Spoilers"]
    let gearPosition = ["Up", "Down"]
    let fuelLoadArray = ["R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10", "R11", "R12"]
    let ktJetArray = ["-2.5","-2.4","-2.3","-2.2-","-2.1","-2.0","-1.9","-1.8","-1.7","-1.6","-1.5","-1.4","-1.3","-1.2","-1.1","-1.0","-0.9","-0.8","-0.7","-0.6","-0.5","-0.4","-0.3","-0.2","-0.1", "0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0", "2.1", "2.2", "2.3", "2.4", "2.5", "2.6", "2.7", "2.8", "2.9", "3.0", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "4.0"]
    let conditionArray = ["Dry", "Wet", "Snow", "Ice"]
    var tempArray = ["0°", "1°", "2°", "3°", "4°", "5°", "6°", "7°", "8°", "9°", "10°", "11°", "12°", "13°", "14°", "15°", "16°", "17°", "18°", "19°", "20°", "21°", "22°", "23°", "24°", "25°", "26°", "27°", "28°", "29°", "30°", "31°", "32°", "33°", "34°", "35°", "36°", "37°", "38°", "39°", "40°", "41°", "42°", "43°", "44°", "45°", "46°", "47°", "48°", "49°", "50°", "51°", "52°", "53°", "54°", "55°", "56°", "57°", "58°", "59°", "60°", "61°", "62°", "63°", "64°", "65°", "66°", "67°", "68°", "69°", "70°", "71°", "72°", "73°", "74°", "75°", "76°", "77°", "78°", "79°", "80°", "81°", "82°", "83°", "84°", "85°", "86°", "87°", "88°", "89°", "90°", "91°", "92°", "93°", "94°", "95°", "96°", "97°", "98°", "99°", "100°", "101°", "102°", "103°", "104°", "105°", "106°", "107°", "108°", "109°", "110°", "111°", "112°", "113°", "114°", "115°", "116°", "117°", "118°", "119°", "120°", "121°", "122°", "123°", "124°", "125°", "126°", "127°", "128°", "129°", "130°"]
    
    let fieldElevArray = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200", "1300", "1400", "1500", "1600", "1700", "1800", "1900", "2000", "2100", "2200", "2300", "2400", "2500", "2600", "2700", "2800", "2900", "3000", "3100", "3200", "3300", "3400", "3500", "3600", "3700", "3800", "3900", "4000", "4100", "4200", "4300", "4400", "4500", "4600", "4700", "4800", "4900", "5000", "5100", "5200", "5300", "5400", "5500", "5600", "5700", "5800", "5900", "6000"]
    let windSpeedArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    let windDirectionArray = ["001°", "002°", "003°", "004°", "005°", "006°", "007°", "008°", "009°", "010°", "011°", "012°", "013°", "014°", "015°", "016°", "017°", "018°", "019°", "020°", "021°", "022°", "023°", "024°", "025°", "026°", "027°", "028°", "029°", "030°", "031°", "032°", "033°", "034°", "035°", "036°", "037°", "038°", "039°", "040°", "041°", "042°", "043°", "044°", "045°", "046°", "047°", "048°", "049°", "050°", "051°", "052°", "053°", "054°", "055°", "056°", "057°", "058°", "059°", "060°", "061°", "062°", "063°", "064°", "065°", "066°", "067°", "068°", "069°", "070°", "071°", "072°", "073°", "074°", "075°", "076°", "077°", "078°", "079°", "080°", "081°", "082°", "083°", "084°", "085°", "086°", "087°", "088°", "089°", "090°", "091°", "092°", "093°", "094°", "095°", "096°", "097°", "098°", "099°", "100°", "101°", "102°", "103°", "104°", "105°", "106°", "107°", "108°", "109°", "110°", "111°", "112°", "113°", "114°", "115°", "116°", "117°", "118°", "119°", "120°", "121°", "122°", "123°", "124°", "125°", "126°", "127°", "128°", "129°", "130°", "131°", "132°", "133°", "134°", "135°", "136°", "137°", "138°", "139°", "140°", "141°", "142°", "143°", "144°", "145°", "146°", "147°", "148°", "149°", "150°", "151°", "152°", "153°", "154°", "155°", "156°", "157°", "158°", "159°", "160°", "161°", "162°", "163°", "164°", "165°", "166°", "167°", "168°", "169°", "170°", "171°", "172°", "173°", "174°", "175°", "176°", "177°", "178°", "179°", "180°", "181°", "182°", "183°", "184°", "185°", "186°", "187°", "188°", "189°", "190°", "191°", "192°", "193°", "194°", "195°", "196°", "197°", "198°", "199°", "200°", "201°", "202°", "203°", "204°", "205°", "206°", "207°", "208°", "209°", "210°", "211°", "212°", "213°", "214°", "215°", "216°", "217°", "218°", "219°", "220°", "221°", "222°", "223°", "224°", "225°", "226°", "227°", "228°", "229°", "230°", "231°", "232°", "233°", "234°", "235°", "236°", "237°", "238°", "239°", "240°", "241°", "242°", "243°", "244°", "245°", "246°", "247°", "248°", "249°", "250°", "251°", "252°", "253°", "254°", "255°", "256°", "257°", "258°", "259°", "260°", "261°", "262°", "263°", "264°", "265°", "266°", "267°", "268°", "269°", "270°", "271°", "272°", "273°", "274°", "275°", "276°", "277°", "278°", "279°", "280°", "281°", "282°", "283°", "284°", "285°", "286°", "287°", "288°", "289°", "290°", "291°", "292°", "293°", "294°", "295°", "296°", "297°", "298°", "299°", "300°", "301°", "302°", "303°", "304°", "305°", "306°", "307°", "308°", "309°", "310°", "311°", "312°", "313°", "314°", "315°", "316°", "317°", "318°", "319°", "320°", "321°", "322°", "323°", "324°", "325°", "326°", "327°", "328°", "329°", "330°", "331°", "332°", "333°", "334°", "335°", "336°", "337°", "338°", "339°", "340°", "341°", "342°", "343°", "344°", "345°", "346°", "347°", "348°", "349°", "350°", "351°", "352°", "353°", "354°", "355°", "356°", "357°", "358°", "359°", "360°"]
    var rwyHDGArray = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36"]
    
    let flaps15Array = ["Yes", "No"]
    let spoilersArray = ["Yes", "No"]
    
    var fuelLoad: FuelLoad = .R0
    var ktJet = 0.0
    var condition: RunwayCondition = .dry
    var tempInF = 0.0
    var fieldElev = 0.0
    var windSpeed = 0.0
    var windDirection = 0.0
    var rwyHdg = 0.0
    var flaps15 = false
    var spoilers = true
    
    var configuration: Configuration = .slickGearUp
    var corrections: Corrections = .none
    var gearUp: Bool = true {
        didSet {
            if gearUp == true {
                switch configuration{
                case .slickGearDown:
                    configuration = .slickGearUp
                case .superPodsGearDown:
                    configuration = .superPodsGearUp
                case .pegGearDown:
                    configuration = .pegGearUp
                default:
                    print("Wierd Science!!")
                }
                switch corrections{
                case .none:
                    corrections = .none
                case .gustUp:
                    corrections = .gustUp
                case .speedBrakeOutGearDown:
                    corrections = .speedBrakeOutGearUp
                case .spoilersUpGearDown:
                    corrections = .spoilersUpGearUp
                case .spoilersUpAndSpeedBrakeOutGearDown:
                    corrections = .spoilersUpAndSpeedBrakeOutGearUp
                default:
                    print("Wierd Science!!")
                }}
            if gearUp == false {
                switch configuration{
                case .slickGearUp:
                    configuration = .slickGearDown
                case .superPodsGearUp:
                    configuration = .superPodsGearDown
                case .pegGearUp:
                    configuration = .pegGearDown
                default:
                    print("Wierd Science!!")
                }
                switch corrections{
                case .none:
                    corrections = .none
                case .gustUp:
                    corrections = .gustUp
                case .speedBrakeOutGearUp:
                    corrections = .speedBrakeOutGearDown
                case .spoilersUpGearUp:
                    corrections = .spoilersUpGearDown
                case .spoilersUpAndSpeedBrakeOutGearUp:
                    corrections = .spoilersUpAndSpeedBrakeOutGearDown
                default:
                    print("Wierd Science!!")
                }}}}
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headwindLabel: UILabel!
    @IBOutlet weak var crosswindLabel: UILabel!
    @IBOutlet weak var takeOffWeightLabel: UILabel!
    @IBOutlet weak var bestGlideLabel: UILabel!
    @IBOutlet weak var minSinkLabel: UILabel!
    @IBOutlet weak var flapsUpLabel: UILabel!
    @IBOutlet weak var flaps35Label: UILabel!
    @IBOutlet weak var toSpeedLabel: UILabel!
    @IBOutlet weak var toDistanceLabel: UILabel!
    @IBOutlet weak var abortStopDistanceLabel: UILabel!
    @IBOutlet weak var inputPickerViewOutlet: UIPickerView!
    @IBOutlet weak var inputViewOutlet: UIView!
    @IBOutlet weak var resultsViewOutlet: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var foreflightViewOutlet: UIView!
    @IBOutlet weak var foreflightGlideOutputOutlet: UIView!
    @IBOutlet weak var configInputOutlet: UIView!
    @IBOutlet weak var configurationPickerViewOutlet: UIPickerView!
    @IBOutlet weak var foreflightGlideNumberLabel: UILabel!
    
    // MARK: - Functions
    func setFormating() {
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let borderWidth: CGFloat = 2
        let cornerRadius: CGFloat = 10
        inputViewOutlet.layer.borderColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        inputViewOutlet.layer.borderWidth = borderWidth
        inputViewOutlet.layer.cornerRadius = cornerRadius
        resultsViewOutlet.layer.borderColor = borderColor
        resultsViewOutlet.layer.borderWidth = borderWidth
        resultsViewOutlet.layer.cornerRadius = cornerRadius
        titleLabel.layer.borderColor = borderColor
        titleLabel.layer.borderWidth = borderWidth
        titleLabel.layer.cornerRadius = cornerRadius
        foreflightViewOutlet.layer.borderColor = #colorLiteral(red: 0.866212666, green: 0.1407547295, blue: 0.03531777859, alpha: 1)
        foreflightViewOutlet.layer.borderWidth = borderWidth
        foreflightViewOutlet.layer.cornerRadius = cornerRadius
        backgroundImageView.image = UIImage(named: "_DSC4679")
    }
    
    
    func savePreviousPickerViewState(fuelLoad: String,
                                     ktJet: String,
                                     condition: String,
                                     tempInF: String,
                                     fieldElev: String,
                                     windSpeed: String,
                                     windDirection: String,
                                     rwyHdg: String,
                                     flaps15: String,
                                     spoilers: String) {
        //Setting User Defaults:
        UserDefaults.standard.set(fuelLoad, forKey: "fuelLoad")
        UserDefaults.standard.set(ktJet, forKey: "ktJet")
        UserDefaults.standard.set(condition, forKey: "condition")
        UserDefaults.standard.set(tempInF, forKey: "tempInF")
        UserDefaults.standard.set(fieldElev, forKey: "fieldElev")
        UserDefaults.standard.set(windSpeed, forKey: "windSpeed")
        UserDefaults.standard.set(windDirection, forKey: "windDirection")
        UserDefaults.standard.set(rwyHdg, forKey: "rwyHdg")
        UserDefaults.standard.set(flaps15, forKey: "flaps15")
        UserDefaults.standard.set(spoilers, forKey: "spoilers")
    }
    
    
    
    
    
    //Retrieving UserDefaults:
    func getDefaults() -> (fuelLoad: String, ktJet: String, condition: String, tempInF: String, fieldElev: String, windSpeed: String, windDirection: String, rwyHdg: String, flaps15: String, spoilers: String){
        var fuelLoad = "R0"
        var ktJet = "0.0"
        var condition = "Dry"
        var tempInF = "59°"
        var fieldElev = "100"
        var windSpeed = "0"
        var windDirection = "001°"
        var rwyHdg = "15"
        var flaps15 = "No"
        var spoilers = "Yes"
        if let fuelLoad_ = UserDefaults.standard.object(forKey: "fuelLoad") {
            fuelLoad = fuelLoad_ as! String
        }
        if let ktJet_ = UserDefaults.standard.object(forKey: "ktJet") {
            ktJet = ktJet_ as! String
        }
        if let condition_ = UserDefaults.standard.object(forKey: "condition") {
            condition = condition_ as! String
        }
        if let tempInF_ = UserDefaults.standard.object(forKey: "tempInF") {
            tempInF = tempInF_ as! String
        }
        if let fieldElev_ = UserDefaults.standard.object(forKey: "fieldElev") {
            fieldElev = fieldElev_ as! String
        }
        if let windSpeed_ = UserDefaults.standard.object(forKey: "windSpeed") {
            windSpeed = windSpeed_ as! String
        }
        if let windDirection_ = UserDefaults.standard.object(forKey: "windDirection") {
            windDirection = windDirection_ as! String
        }
        if let rwyHdg_ = UserDefaults.standard.object(forKey: "rwyHdg") {
            rwyHdg = rwyHdg_ as! String
        }
        if let flaps15_ = UserDefaults.standard.object(forKey: "flaps15") {
            flaps15 = flaps15_ as! String
        }
        if let spoilers_ = UserDefaults.standard.object(forKey: "spoilers") {
            spoilers = spoilers_ as! String
        }
        return (fuelLoad: fuelLoad, ktJet: ktJet, condition: condition, tempInF: tempInF, fieldElev: fieldElev, windSpeed: windSpeed, windDirection: windDirection, rwyHdg: rwyHdg, flaps15: flaps15, spoilers: spoilers)
    }
    
    
    func calculateTold() {
        let told = U2Told(fuelLoad: fuelLoad,
                          ktJet: ktJet,
                          runwayCondition: condition,
                          tempInF: tempInF,
                          fieldElev: fieldElev,
                          windSpeed: windSpeed,
                          windDirection: windDirection,
                          runwayHeading: rwyHdg * 10,
                          flaps15: flaps15,
                          SpoilersDeployed: spoilers)
        
        headwindLabel.text = "\(String(format: "%.0f", told.windComponents().headWind))"
        crosswindLabel.text = "\(String(format: "%.0f", told.windComponents().crossWind))"
        takeOffWeightLabel.text = "\(String(format: "%.0f",told.takeOffWeight()))"
        bestGlideLabel.text = "\(String(format: "%.0f",told.airspeeds().bestGlide))"
        minSinkLabel.text = "\(String(format: "%.0f",told.airspeeds().minSink))"
        flapsUpLabel.text = "\(String(format: "%.0f",told.airspeeds().flapsUp))"
        flaps35Label.text = "\(String(format: "%.0f",told.airspeeds().flaps35))"
        toSpeedLabel.text = "\(String(format: "%.0f",told.takeOffGroundDistanceChartP3().takeOffSpeed))"
        toDistanceLabel.text = "\(String(format: "%.0f",told.takeOffGroundDistanceChartP3().takeOffDistance))"
        if told.abortStoppingDistancePW() != 0.0 {
            abortStopDistanceLabel.text = "\(String(format: "%.0f",told.abortStoppingDistancePW()))"
        } else {
            abortStopDistanceLabel.text = "Not Avail"
        }
        
    }
    
    func calculateGlideNumber(){
        let result = (self.configuration.rawValue + self.corrections.rawValue).nauticalMilesToFeet / 10000
        foreflightGlideNumberLabel.text = "\(String(format: "%.1f", result)) : 1"
    }
    
    func initialPickerViewLoad(fuelLoad: String,
                               ktJet: String,
                               condition: String,
                               tempF: String,
                               fieldElev: String,
                               windSpeed: String,
                               windDir: String,
                               rwyHdg: String,
                               flaps15: String,
                               spoilers: String) {
        let component00 = fuelLoadArray.index(of: fuelLoad)
        let component01 = ktJetArray.index(of: ktJet)
        let component02 = conditionArray.index(of: condition)
        let component03 = tempArray.index(of: tempF)
        let component04 = fieldElevArray.index(of: fieldElev)
        let component05 = windSpeedArray.index(of: windSpeed)
        let component06 = windDirectionArray.index(of: windDir)
        let component07 = rwyHDGArray.index(of: rwyHdg)
        let component08 = flaps15Array.index(of: flaps15)
        let component09 = spoilersArray.index(of: spoilers)
        self.inputPickerViewOutlet.selectRow(component00!, inComponent: 0, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component00!, inComponent: 0)
        self.inputPickerViewOutlet.selectRow(component01!, inComponent: 1, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component01!, inComponent: 1)
        self.inputPickerViewOutlet.selectRow(component02!, inComponent: 2, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component02!, inComponent: 2)
        self.inputPickerViewOutlet.selectRow(component03!, inComponent: 3, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component03!, inComponent: 3)
        self.inputPickerViewOutlet.selectRow(component04!, inComponent: 4, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component04!, inComponent: 4)
        self.inputPickerViewOutlet.selectRow(component05!, inComponent: 5, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component05!, inComponent: 5)
        self.inputPickerViewOutlet.selectRow(component06!, inComponent: 6, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component06!, inComponent: 6)
        self.inputPickerViewOutlet.selectRow(component07!, inComponent: 7, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component07!, inComponent: 7)
        self.inputPickerViewOutlet.selectRow(component08!, inComponent: 8, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component08!, inComponent: 8)
        self.inputPickerViewOutlet.selectRow(component09!, inComponent: 9, animated: false)
        self.pickerView(self.inputPickerViewOutlet, didSelectRow: component09!, inComponent: 9)
    }
    func fuelLoadFromInputArray(index: Int) -> FuelLoad {
        var fuelLoad: FuelLoad = .R0
        let fl = fuelLoadArray[index]
        switch fl {
        case "R0":
            fuelLoad = .R0
        case "R1":
            fuelLoad = .R1
        case "R2":
            fuelLoad = .R2
        case "R3":
            fuelLoad = .R3
        case "R4":
            fuelLoad = .R4
        case "R5":
            fuelLoad = .R5
        case "R6":
            fuelLoad = .R6
        case "R7":
            fuelLoad = .R7
        case "R8":
            fuelLoad = .R8
        case "R9":
            fuelLoad = .R9
        case "R10":
            fuelLoad = .R10
        case "R11":
            fuelLoad = .R11
        case "R12":
            fuelLoad = .R12
        default:
            print("Nope")
        }
        return fuelLoad
    }
    func conditionFromInputArray(index: Int) -> RunwayCondition {
        var condition: RunwayCondition = .dry
        let cond = conditionArray[index]
        switch cond {
        case "Dry":
            condition = .dry
        case "Wet":
            condition = .wet
        case "Snow":
            condition = .snow
        case "Ice":
            condition = .ice
        default:
            print("Nope")
        }
        return condition
    }
    func getFlaps15FromInputArray(index: Int) -> Bool {
        var flaps15 = true
        if flaps15Array[index] == "Yes" {
            flaps15 = true
        } else if flaps15Array[index] == "No" {
            flaps15 = false
        }
        return flaps15
    }
    func getSpoilersFromInputArray(index: Int) -> Bool {
        var spoilers = true
        if spoilersArray[index] == "Yes" {
            spoilers = true
        } else if spoilersArray[index] == "No" {
            spoilers = false
        }
        return spoilers
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == inputPickerViewOutlet {
            return 10
        }
        if pickerView == configurationPickerViewOutlet {
            return 3
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        func atString(string: String) -> NSAttributedString? {
            let at = NSAttributedString(string: string, attributes: [NSAttributedStringKey.backgroundColor:UIColor.clear,NSAttributedStringKey.font:UIFont.init(name: "Times", size: 8.0)!,NSAttributedStringKey.foregroundColor:UIColor.yellow])
            return at
        }
        
        func redString(string: String) -> NSAttributedString? {
            let at = NSAttributedString(string: string, attributes: [NSAttributedStringKey.backgroundColor:UIColor.clear,NSAttributedStringKey.font:UIFont.init(name: "Times", size: 8.0)!,NSAttributedStringKey.foregroundColor:UIColor.red])
            return at
        }
        func whiteString(string: String) -> NSAttributedString? {
            let at = NSAttributedString(string: string, attributes: [NSAttributedStringKey.backgroundColor:UIColor.clear,NSAttributedStringKey.font:UIFont.init(name: "Times", size: 8.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            return at
        }
        if pickerView == inputPickerViewOutlet {
            switch component {
            case 0:
                return atString(string: fuelLoadArray[row])!
            case 1:
                return atString(string: ktJetArray[row])
            case 2:
                return atString(string: conditionArray[row])
            case 3:
                return atString(string: tempArray[row])
            case 4:
                return atString(string: fieldElevArray[row])
            case 5:
                return atString(string: windSpeedArray[row])
            case 6:
                return atString(string: windDirectionArray[row])
            case 7:
                return atString(string: rwyHDGArray[row])
            case 8:
                return redString(string: flaps15Array[row])
            case 9:
                return redString(string: spoilersArray[row])
            default:
                return atString(string: "")
            }
        }
        if pickerView == configurationPickerViewOutlet {
                switch component {
                case 0:
                    return whiteString(string: configurationArray[row])
                case 1:
                    return whiteString(string: correctionsArray[row])
                case 2:
                    return whiteString(string: gearPosition[row])
                default:
                    return whiteString(string: "")
                }
        }
        return nil
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == inputPickerViewOutlet {
            switch component {
            case 0:
                fuelLoad = fuelLoadFromInputArray(index: row)
                UserDefaults.standard.set(fuelLoadArray[row], forKey: "fuelLoad")
                print(fuelLoad)
            case 1:
                ktJet = Double(ktJetArray[row])!
                UserDefaults.standard.set(ktJetArray[row], forKey: "ktJet")
                print(ktJet)
            case 2:
                condition = conditionFromInputArray(index: row)
                UserDefaults.standard.set(conditionArray[row], forKey: "condition")
                print(condition)
            case 3:
                tempInF = Double(tempArray[row].dropLast())!
                UserDefaults.standard.set(tempArray[row], forKey: "tempInF")
                print(tempInF)
            case 4:
                fieldElev = Double(fieldElevArray[row])!
                UserDefaults.standard.set(fieldElevArray[row], forKey: "fieldElev")
                print(fieldElev)
            case 5:
                windSpeed = Double(windSpeedArray[row])!
                UserDefaults.standard.set(windSpeedArray[row], forKey: "windSpeed")
                print(windSpeed)
            case 6:
                windDirection = Double(windDirectionArray[row].dropLast())!
                UserDefaults.standard.set(windDirectionArray[row], forKey: "windDirection")
                print(windDirection)
            case 7:
                rwyHdg = Double(rwyHDGArray[row])!
                UserDefaults.standard.set(rwyHDGArray[row], forKey: "rwyHdg")
                print(rwyHdg)
            case 8:
                flaps15 = getFlaps15FromInputArray(index: row)
                UserDefaults.standard.set(flaps15Array[row], forKey: "flaps15")
                print(flaps15)
            case 9:
                spoilers = getSpoilersFromInputArray(index: row)
                UserDefaults.standard.set(spoilersArray[row], forKey: "spoilers")
                print(spoilers)
            default:
                print("")
            }
            calculateTold()
        }
        if pickerView == configurationPickerViewOutlet {
            switch component {
            case 0:
                switch row {
                case 0:
                    if gearUp {configuration = .slickGearUp} else {configuration = .slickGearDown}
                case 1:
                    if gearUp {configuration = .superPodsGearUp} else {configuration = .superPodsGearDown}
                case 2:
                    if gearUp {configuration = .pegGearUp} else {configuration = .pegGearDown}
                default:
                    print("Error in Configuration")
                }
                UserDefaults.standard.set(configurationArray[row], forKey: "configuration")
                print(configuration)
                calculateGlideNumber()
            case 1:
                switch row {
                case 0:
                    corrections = .none
                case 1:
                    corrections = .gustUp
                case 2:
                    if gearUp {corrections = .speedBrakeOutGearUp} else {corrections = .speedBrakeOutGearDown}
                case 3:
                    if gearUp {corrections = .spoilersUpGearUp} else {corrections = .spoilersUpGearDown}
                case 4:
                    if gearUp {corrections = .spoilersUpAndSpeedBrakeOutGearUp} else {corrections = .spoilersUpAndSpeedBrakeOutGearDown}
                default:
                    print("Error in corrections")
                }
                UserDefaults.standard.set(correctionsArray[row], forKey: "corrections")
                print(corrections)
                calculateGlideNumber()
            case 2:
                switch row {
                case 0:
                    gearUp = true
                case 1:
                    gearUp = false
                default:
                    print("Error in gear position")
                }
                UserDefaults.standard.set(gearPosition[row], forKey: "gearPosition")
                print(configuration)
                print(corrections)
                calculateGlideNumber()
            default:
                print("")
            }}
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == inputPickerViewOutlet {
            switch component {
            case 0:
                return fuelLoadArray.count
            case 1:
                return ktJetArray.count
            case 2:
                return conditionArray.count
            case 3:
                return tempArray.count
            case 4:
                return fieldElevArray.count
            case 5:
                return windSpeedArray.count
            case 6:
                return windDirectionArray.count
            case 7:
                return rwyHDGArray.count
            case 8:
                return flaps15Array.count
            case 9:
                return spoilersArray.count
            default:
                return 0
            }}
        if pickerView == configurationPickerViewOutlet {
            switch component {
            case 0:
                return configurationArray.count
            case 1:
                return correctionsArray.count
            case 2:
                return gearPosition.count
            default:
                return 0
        }}
        return 1
    }
    
 
}
