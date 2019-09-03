//
//  CustomKmlAnnotations.swift
//  Dragon Fire
//
//  Created by elmo on 6/15/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import CoreData

class PathKmlAnnotations: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,  UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        pc = appDelegate.persistentContainer
        setFormatting()
        polygonsInCoreData = cdu.getPolygon(pc: pc)
    }
    
    // MARK: - Setup
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pc: NSPersistentContainer!
    let cdu = CoreDataUtilities()
    var polygonsInCoreData: [PolygonCD] = []
    
    
    @IBOutlet weak var coordListTextViewOutlet: UITextView!
    
    

    var kmlPolyNameCounter: Int = 1 {
        didSet {
            
        }}
    var coordsForCurrentPoly: [[Double]] = [] {
        didSet {
            
        }}
    var lineColor: ColorKML = .black {
        didSet {
            print(lineColor)
        }}
    var lineOpacity: Transparency = ._100 {
        didSet {
            print(lineOpacity)
        }}
    var lineThickness: Int16 = 1 {
        didSet {
            print(lineThickness)
        }}
    var polyColor: ColorKML = .black {
        didSet {
            print(polyColor)
        }}
    var polyOpacity: Transparency = ._5 {
        didSet {
            print(polyOpacity)
        }}
    var isClosedPath: Bool = true {
        didSet {
            switch isClosedPath {
            case true:
                isClosedSwitchLabel.text = "Yes"
            case false:
                isClosedSwitchLabel.text = "No"
            }}}
    var isFilledIn: Bool = true {
        didSet {
            switch isFilledIn {
            case true:
                isFilledInSwitchLabel.text = "Yes"
            case false:
                isFilledInSwitchLabel.text = "No"
            }}}
    var includedInBL: Bool = true {
        didSet {
            switch includedInBL {
            case true:
                includedInBLSwitchLabel.text = "Yes"
            case false:
                includedInBLSwitchLabel.text = "No"
            }}}
    
    var showInputView: Bool = false {
        didSet {
            let upChevron = UIImage(named: "icons8-chevron_up_round")
            let downChevron = UIImage(named: "icons8-chevron_down_round")
            switch showInputView {
            case true:
                inputHeightConstraint.constant = 620
                inputViewOutlet.isHidden = false
                addNewPathShowInputViewOutlet.setImage(upChevron, for: .normal)
            case false:
                inputHeightConstraint.constant = 0
                inputViewOutlet.isHidden = true
                addNewPathShowInputViewOutlet.setImage(downChevron, for: .normal)
                addNewPathShowInputViewOutlet.standardRoundButtonFormatting(cornerRadius: true)
                addNewPathShowInputViewOutlet.layer.cornerRadius = 15
            }}}

    
    // MARK: - Outlets
    
    @IBOutlet var switchOutlets: [UISwitch]!
    @IBOutlet weak var pathTableView: UITableView!
    @IBOutlet weak var addNewPathPlusButtonwidth: NSLayoutConstraint!
    @IBOutlet weak var addNewPathPlusButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var addNewPathShowInputViewOutlet: UIButton!
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var coordInfoButtonOutlet: UIButton!
    @IBOutlet weak var coordTextFieldOutlet: UITextView!
    @IBOutlet weak var clearButtonOutlet: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var exportToFFButtonOutlet: UIButton!
    @IBOutlet weak var deleteAllButtonOutlet: UIButton!
    @IBOutlet weak var inputViewOutlet: UIView!
    @IBOutlet weak var nameViewOutlet: UIView!
    @IBOutlet weak var coordListTextView: UITextView!
    @IBOutlet weak var pickerWindowViewOutlet: UIView!
    @IBOutlet weak var coordInputWindowView: UIView!
    @IBOutlet weak var switchWindowView: UIView!
    @IBOutlet weak var isClosedSwitchLabel: UILabel!
    @IBAction func isClosedPathSwitch(_ sender: UISwitch) {
        if sender.isOn {
            isClosedPath = true
        } else {
            isClosedPath = false
        }}
    @IBOutlet weak var isFilledInSwitchLabel: UILabel!
    @IBAction func isFilledInSwitch(_ sender: UISwitch) {
        if sender.isOn {
            isFilledIn = true
        } else {
            isFilledIn = false
        }}
    @IBOutlet weak var includedInBLSwitchLabel: UILabel!
    @IBAction func includedInBLSwitch(_ sender: UISwitch) {
        if sender.isOn {
            includedInBL = true
        } else {
            includedInBL = false
        }}
    
    
    //COORD VARIABLES
    var coordsToPathArray: [String] = [] {
        didSet {
        }}
    
    func getCoordsFromTextView(_ coordString: String?) -> [[Double]]{
        var returnArray: [[Double]] = []
        if let coordInput = coordString {
            let latLongString00 = coordInput.trimmingCharacters(in: .whitespacesAndNewlines).filter { $0 != Character(" ")}
            let latLongString01 = latLongString00.components(separatedBy: "\n")
            for latLong in latLongString01 {
                var latLongDouble: [Double] = []
                do {
                    let latLon = try LatLon.parseLatLon(stringToParse: latLong)
                    latLongDouble.append(latLon.lon)
                    latLongDouble.append(latLon.lat)
                    latLongDouble.append(0.0)
                } catch {
                    print(error)
                }
                returnArray.append(latLongDouble)
                if returnArray.last == [0.0,0.0,0.0] {
                    returnArray.removeLast()
                }
            }
        }
        print(returnArray)
        return returnArray
    }

    //Delete Button
    @IBAction func clearAllCurrentCoordsButton(_ sender: UIButton) {
        coordListTextView.text = ""
        nameTextField.text = ""
    }
    //Add Button
    @IBAction func addButton(_ sender: UIButton) {
        if nameTextField.text == nil || nameTextField.text == "" {
            let alertController = UIAlertController(title: "Name Missing", message:
                "Please enter a unique name for the path for the database", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true)
        } else {
            coordsForCurrentPoly = getCoordsFromTextView(coordListTextView.text)
            print(coordsForCurrentPoly)
            print(coordsForCurrentPoly.count    )
            cdu.addPolygon(closed: isClosedPath,
                           coords: coordsForCurrentPoly,
                           filledIn: isFilledIn,
                           includedInBL: includedInBL,
                           lineColor: lineColor.rawValue,
                           lineOpacity: lineOpacity.rawValue,
                           name: nameTextField.text ?? "No Name",
                           polyColor: polyColor.rawValue,
                           polyOpacity: polyOpacity.rawValue,
                           width: Int(lineThickness),
                           pc: pc)
            polygonsInCoreData = cdu.getPolygon(pc: pc)
            pathTableView.reloadData()
        }
        
    }
    
    @IBAction func deleteAllPathsFromCDButton(_ sender: UIButton) {
        cdu.deleteAllPolyonsFromDB(pc: pc)
        print(cdu.getPolygon(pc: pc).count)
        polygonsInCoreData = cdu.getPolygon(pc: pc)
        pathTableView.reloadData()
       
    }
    
    @IBAction func addNewPathShowInputViewButton(_ sender: UIButton) {
        switch showInputView {
        case true:
            showInputView = false
        case false:
            showInputView = true
        }
    }
    
    // MARK: - Functions
    func setFormatting() {
        pathTableView.rowHeight = 135
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let cornerRadius: CGFloat = 5

        pathTableView.layer.borderColor = borderColor
        pathTableView.layer.borderWidth = borderWidth
        pathTableView.layer.cornerRadius = cornerRadius
        for eachSwitch in switchOutlets {
            eachSwitch.onTintColor = #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3960784314, alpha: 1)
        }
        
        coordInfoButtonOutlet.standardRoundButtonFormatting(cornerRadius: true)
        nameViewOutlet.layer.borderColor = borderColor
        nameViewOutlet.layer.borderWidth = borderWidth
        nameViewOutlet.layer.cornerRadius = cornerRadius
        pickerWindowViewOutlet.layer.borderColor = borderColor
        pickerWindowViewOutlet.layer.borderWidth = borderWidth
        pickerWindowViewOutlet.layer.cornerRadius = cornerRadius
        coordInputWindowView.layer.borderColor = borderColor
        coordInputWindowView.layer.borderWidth = borderWidth
        coordInputWindowView.layer.cornerRadius = cornerRadius
        switchWindowView.layer.borderColor = borderColor
        switchWindowView.layer.borderWidth = borderWidth
        switchWindowView.layer.cornerRadius = cornerRadius
        coordListTextView.layer.borderColor = borderColor
        coordListTextView.layer.borderWidth = borderWidth
        coordListTextView.layer.cornerRadius = cornerRadius
        pickerWindowViewOutlet.layer.borderColor = borderColor
        pickerWindowViewOutlet.layer.borderWidth = borderWidth
        pickerWindowViewOutlet.layer.cornerRadius = cornerRadius
        inputViewOutlet.layer.borderColor = borderColor
        inputViewOutlet.layer.borderWidth = borderWidth
        inputViewOutlet.layer.cornerRadius = cornerRadius
        exportToFFButtonOutlet.standardButtonFormatting(cornerRadius: true)
        clearButtonOutlet.layer.borderColor = borderColor
        clearButtonOutlet.layer.borderWidth = borderWidth
        clearButtonOutlet.layer.cornerRadius = cornerRadius
        addButtonOutlet.layer.borderColor = borderColor
        addButtonOutlet.layer.borderWidth = borderWidth
        addButtonOutlet.layer.cornerRadius = cornerRadius
        
        deleteAllButtonOutlet.layer.borderColor = borderColor
        deleteAllButtonOutlet.layer.borderWidth = borderWidth
        deleteAllButtonOutlet.layer.cornerRadius = cornerRadius
        
        nameTextField.layer.borderColor = borderColor
        nameTextField.layer.borderWidth = borderWidth
        nameTextField.layer.cornerRadius = cornerRadius
        
        addNewPathShowInputViewOutlet.standardRoundButtonFormatting(cornerRadius: true)
        addNewPathShowInputViewOutlet.layer.cornerRadius = 15
        showInputView = false
    }
    func generateKml() -> String {
        let allPaths = cdu.getPolygon(pc: pc)
        var pathKMLContainer = ""
        for path in allPaths {
            let lineColor = ColorKML(rawValue: path.lineColor_CD ?? "000000") ?? .black
            let lineOpacity = Transparency(rawValue: path.lineOpacity_CD ?? "ff") ?? ._100
            let polyColor = ColorKML(rawValue: path.polyColor_CD ?? "000000") ?? .black
            let polyOpacity = Transparency(rawValue: path.polyOpacity_CD ?? "1e") ?? ._30
            let width = Int(path.width_CD)
            let internalKML = PolygonKML(name: path.name_CD ?? "none",
                                         description: "none",
                                         extrude: .off,
                                         tesselate: .off,
                                         altMode: .absolute,
                                         coords: path.coords_CD!,
                                         lineColor: lineColor,
                                         lineOpacity: lineOpacity,
                                         polyColor: polyColor,
                                         polyOpacity: polyOpacity,
                                         width: width)
            if path.closed_CD == true {
                pathKMLContainer += internalKML.filledInPolygon()
            } else {
                pathKMLContainer += internalKML.lineGenerator()
            }}
        let pathKMLFull = OpenCloseKML(kmlItems: pathKMLContainer).KMLGenerator()
        return pathKMLFull
        //        self.passToShareSheet(fileName: "Paths", ext: "kml", stringToWriteToFile: pathKMLFull)
    }
    
    // MARK: - Seque Stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "coordInfoPopupSegue"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
    // MARK: - Buttons and Controls
    @IBAction func exportKMLToForeFlightButton(_ sender: UIButton) {
        self.passToShareSheetWithfileNamePopupWith(placeHolder: "Paths", ext: "kml", stingToWrite: generateKml())
    }
    
    @IBAction func nameTextFieldPrimaryAction(_ sender: UITextField) {
        coordListTextViewOutlet.becomeFirstResponder()
    }
    
    // MARK: - PickerView
    let lineWidthArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12", "13", "15", "16", "17", "18", "19", "20", ]
    //let lineWidthArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var colorArray = ["Black", "Red", "Orange", "LightYellow", "DarkGreen", "Blue"]
    var iconTypeArray = ["bluePin", "greenPin", "lightBluePin","pinkPin","purplePin", "yellowPin", "whitePin"]
    var fillOpacityArray = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "100"]
    var fillOpacityDict: [String:Transparency] = ["5":._5, "10":._10, "15":._15, "20":._20, "25":._25, "30":._30, "35":._35, "40":._40, "45":._45, "50":._50, "55":._55, "60":._60, "65":._65, "70":._70, "75":._75, "80":._80, "85":._85, "90":._90, "95":._95, "100":._100]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return colorArray.count
        } else if component == 1 {
            return lineWidthArray.count
        } else if component == 2 {
            return colorArray.count
        } else {
            return fillOpacityArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if let lineColor_ = ColorKML(rawValue: colorArray[row].switchColorImageToCode()) {
                lineColor = lineColor_
            }
        } else if component == 1 {
            lineThickness = Int16(lineWidthArray[row]) ?? 5
        } else if component == 2 {
            if let lineColor_ = ColorKML(rawValue: colorArray[row].switchColorImageToCode()) {
                polyColor = lineColor_
            }
        } else {
            polyOpacity = fillOpacityDict[fillOpacityArray[row]] ?? ._50
        }}
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 0 {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: colorArray[row]))
            return myImageView
        } else if component == 1 {
            let widthList = UILabel()
            widthList.textAlignment = .center
            widthList.text = lineWidthArray[row]
            widthList.font = UIFont.boldSystemFont(ofSize: 22)
            return widthList
        } else if component == 2 {
            var myImageView = UIImageView()
            myImageView = UIImageView(image: UIImage(named: colorArray[row]))
            return myImageView
        } else {
            let fillOpacity = UILabel()
            fillOpacity.textAlignment = .center
            fillOpacity.text = fillOpacityArray[row]
            fillOpacity.font = UIFont.boldSystemFont(ofSize: 22)
            return fillOpacity
        }}
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polygonsInCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pathCell", for: indexPath) as! PathTableViewCell
        cell.pathNameLabel.text = polygonsInCoreData[indexPath.row].name_CD
        cell.pathClosedLabel.indicatorLabelIsOnRound(polygonsInCoreData[indexPath.row].closed_CD)
        cell.pathFilledInLabel.indicatorLabelIsOnRound(polygonsInCoreData[indexPath.row].filledIn_CD)
        cell.includedInBLLabel.indicatorLabelIsOnRound(polygonsInCoreData[indexPath.row].includedInBL_CD)
        
        
        cell.pathModelLabel.layer.cornerRadius = cell.pathModelLabel.frame.width/2
        cell.pathModelLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.pathModelLabel.layer.borderWidth = 3

        let borderWidth = CGFloat(polygonsInCoreData[indexPath.row].width_CD)
        cell.pathModelLabel.layer.borderWidth = borderWidth
        let lineColor = polygonsInCoreData[indexPath.row].lineColor_CD
        cell.pathModelLabel.layer.borderColor = lineColor?.getCGColor()
        if polygonsInCoreData[indexPath.row].filledIn_CD == true {
            let backGroundColor = polygonsInCoreData[indexPath.row].polyColor_CD
            let polyOpacity = polygonsInCoreData[indexPath.row].polyOpacity_CD
            cell.pathModelLabel.backgroundColor = backGroundColor?.getUIColor().withAlphaComponent(polyOpacity?.getAlpha() ?? 0)
        } else {
            cell.pathModelLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let path = polygonsInCoreData[indexPath.row].name_CD {
                do {
                    cdu.deletePolygonNamed(path, pc: pc)
                    polygonsInCoreData.remove(at: indexPath.row)
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
    
    
    

    
}
