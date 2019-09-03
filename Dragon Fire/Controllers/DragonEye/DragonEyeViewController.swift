//
//  DragonEyeViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 8/19/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import CoreMotion


class DragonEyeViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getpositionPermission()
        setupViewSight()
        pilotAndBEViewFormatting()
        getOrientation()
        getPosition()
        setMarkCounter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadBullsEye()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if selectedBullsEye != nil {
        }}
    
    // MARK: - Set Up Variables
    let simulatedAltitude = 70_000.00.feetToMeters // REMOVE FOR EXPORT
    var POI_Counter = 0
    var latOfDevice = 0.0
    var longOfDevice = 0.0
    var altOfDevice = 0.0
    var pitchAngleOfDevice = 0.0 {
        didSet{
            if pitchAngleOfDevice > 89.9 {
                pitchAngleOfDevice = 89.9
            }}}
    var headingOfDevice = 0.0 //{didSet{calculatePOI();updateDisplay()}}
    var rollOfDevice = 0.0
    var yawOfDevice = 0.0
    var bearingToPOI = 0.0
    var latOfPOI = 0.0
    var longOfPOI = 0.0
    var distanceOfPOI = 0.0
    var magVar = 0.0
    var latLongOfPOI = ""
    var mgrsOfPOI: Mgrs?
    var utmOfPOI: Utm?
    var poiRangeOffBE = 0.0
    var poiBearingOffBE = 0.0
    let motionManager = CMMotionManager()
    let locManager = CLLocationManager()
    let cdu = CoreDataUtilities()
    let gonk = Calculations()
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // Mark Store items:
    var markBullseyeRefName = ""
    var markPilotAlt = 0.0
    var markPilotCoords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var markPilotHeadingTrue = 0.0
    var markPilotHeadingMag = 0.0
    var markMagVar = 0.0
    var markTime = Date()
    var markBearingofPOItoBullsEye = 0.0
    var markDistanceofPOItoBullsEye = 0.0
    var markPOICoords = ""
    var markPOIUTM = ""
    var markPOIMGRS = ""
    
    var orientationRawValue: Int = 1 {
        didSet {
            switch orientationRawValue {
            case 1:
                print("Home Button Bottom")
            case 2:
                print("Home Button Top")
            case 3:
                print("Home Button Right")
            case 4:
                print("Home Button Left")
            default:
                print("Where'd the home button go?!?")
            }}}
    
    var indexPathRowOfSelectedBE: Int? {
        didSet {
            UserDefaults.standard.set(indexPathRowOfSelectedBE, forKey: "indexPathRowOfSelectedBE")
            if cdu.getBullseye(pc: pc).count != 0 {
                print("Number of BE: \(cdu.getBullseye(pc: pc).count)")
                print("InexPathRow: \(String(describing: indexPathRowOfSelectedBE))")
                if cdu.getBullseye(pc: pc)[indexPathRowOfSelectedBE!] != nil {
                    selectedBullsEye = cdu.getBullseye(pc: pc)[indexPathRowOfSelectedBE!]
                }
                
            }}}
    
    var selectedBullsEye: BullseyeCD? {
        didSet {
            if selectedBullsEye == nil {
                bullsEyeView.isHidden = true
            } else {
                bullsEyeView.isHidden = false
            }}}
    
    func loadBullsEye() {
        if cdu.getBullseye(pc: pc).count != 0 {
            if let indexPathRowOfSelectedBE_ = UserDefaults.standard.object(forKey: "indexPathRowOfSelectedBE") {
                print("1: **** \(indexPathRowOfSelectedBE_)")
                indexPathRowOfSelectedBE = indexPathRowOfSelectedBE_ as? Int
                bullsEyeView.isHidden = false
                print("*************************")
            }} else {
            print("?????????????????????????")
            indexPathRowOfSelectedBE = nil
            selectedBullsEye = nil
            bullsEyeView.isHidden = true
        }}

    // MARK: - Outlets
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var hudImageView: UIView!
    @IBOutlet var infoViews: [UIView]!
    @IBOutlet weak var bullsEyeView: UIView!
    
    // MARK: Pilot Labels:
    @IBOutlet weak var pilotNameLabel: UILabel!
    @IBOutlet weak var pilotRangeLabel: UILabel!
    @IBOutlet weak var pilotBearingLabel: UILabel!
    @IBOutlet weak var pilotLatLonLabel: UILabel!
    @IBOutlet weak var pilotLonLabel: UILabel!
    @IBOutlet weak var pilotUTMLabel: UILabel!
    @IBOutlet weak var pilotMGRSLabel: UILabel!
    // MARK: BullsEye Labels:
    @IBOutlet weak var bullsEyeNameLabel: UILabel!
    @IBOutlet weak var bullsEyeRangeLabel: UILabel!
    @IBOutlet weak var bullsEyeBearingLabel: UILabel!
    @IBOutlet weak var bullsEyeLatLonLabel: UILabel!
    @IBOutlet weak var bullsEyeUTMLabel: UILabel!
    @IBOutlet weak var bullsEyeMGRSLabel: UILabel!
    @IBOutlet weak var markButtonBlur: UIVisualEffectView!
    @IBOutlet weak var bullsEyeButtonBlur: UIVisualEffectView!
    @IBOutlet weak var exportButtonBlur: UIVisualEffectView!
    @IBOutlet weak var storedPOIsBlur: UIVisualEffectView!
    @IBOutlet weak var markStoreCounter: UILabel!
    // MARK: Buttons:
    
    @IBOutlet weak var bullsEyeButtonOutlet: UIButton!
    @IBOutlet weak var storedFixesButtonOutlet: UIButton!
    @IBOutlet weak var markStoreButtonOutlet: UIButton!
    @IBOutlet weak var exportToForeFlightButtonOutlet: UIButton!
    
    
    // MARK: - TIE USER INTERFACE HERE
    // Updates Display real time : Everytime the heading of the device is changed this updates the display
    func updateDisplay() {
        // add or adjust as you see fit
        if distanceOfPOI.isNaN {
            pilotRangeLabel.text = "Range: ∞ NM"
            pilotBearingLabel.text = "Bearing: ∞ °"
            pilotLatLonLabel.text = "∞"
            pilotLonLabel.text = "∞"
            pilotMGRSLabel.text = "∞"
            pilotUTMLabel.text = "∞"
        } else  {
            pilotRangeLabel.text = "Range: \(String(format: "%.0f",distanceOfPOI))NM"
            pilotBearingLabel.text = "Bearing: \(String(format: "%.0f",bearingToPOI))°"
            pilotLatLonLabel.text = "\(latLongOfPOI.substring(from: 0, to: 11))"
            pilotLonLabel.text = "\(latLongOfPOI.substring(from: 13, to: latLongOfPOI.count))"
            let mgrs = mgrsOfPOI?.toString(precision: 3) ?? ""
            let utmString6Digit = "\(utmOfPOI?.toString().substring(from: 0, to: 8) ?? "") \(utmOfPOI?.toString().substring(from: 12, to: ((utmOfPOI?.toString().count)! - 3)) ?? "")"
            pilotMGRSLabel.text = mgrs
            pilotUTMLabel.text = utmString6Digit
  
        }
        if let selectedBullsEye_ = selectedBullsEye {
            bullsEyeNameLabel.text = "POI ➠ \(selectedBullsEye_.bullsEyeName_CD?.substring(from: 0, to: 6) ?? "BE/SD")"
            bullsEyeRangeLabel.text = "Range: \(String(format: "%.0f",poiRangeOffBE))NM"
            bullsEyeBearingLabel.text = "Bearing: \(String(format: "%.0f",poiBearingOffBE))°"
        }
        
        
        
        
    }
    
    func setMarkCounter() {
        markStoreCounter.text = "\(cdu.getMarkStore(pc: pc).count)"
    }
    
    // MARK: - Camera Setup
    func setupViewSight() {
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                    captureSession = AVCaptureSession()
                    captureSession?.addInput(input)
            } catch {print(error)}
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
        }
    }
    
    //Adjusts the orientation of the camera when device is rotated
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let videoLayer = self.videoPreviewLayer
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            guard let connection = videoLayer?.connection,
                connection.isVideoOrientationSupported,
                let orientation = AVCaptureVideoOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue) else {
                    return
            }
            connection.videoOrientation = orientation
            self.orientationRawValue = orientation.rawValue
            videoLayer?.frame = self.view.bounds
        }) { (context: UIViewControllerTransitionCoordinatorContext) in
        }}
    
    // MARK: - Calculations
    func headingOrientationCorrection(_ cFactor: Double, trueHeading: CLLocationDirection) -> Double {
        var heading = 0.0
        heading = cFactor + trueHeading
        if heading > 360 {
            heading = heading - 360
        }
        return heading
    }
    
    func calculatePOI() {
        let poiInfo = gonk.poiCalc(deviceLat: latOfDevice, deviceLong: longOfDevice, deviceAlt: altOfDevice, devicePitch: pitchAngleOfDevice, deviceRoll: rollOfDevice, deviceHdgTrue: headingOfDevice)
        
        latOfPOI = poiInfo.poiLat
        longOfPOI = poiInfo.poiLong
        distanceOfPOI = poiInfo.poiDist
        let poiRandB = gonk.rangeAndBearing(latitude_01: latOfDevice, longitude_01: longOfDevice, latitude_02: latOfPOI, longitude_02: longOfPOI, magVar: magVar)
        bearingToPOI = poiRandB.bearing
        if let selectedBullsEye_ = selectedBullsEye {
            if let cp = selectedBullsEye_.centerPoint_CD {
                let poiRandB = gonk.rangeAndBearing(latitude_01: cp[0], longitude_01: cp[1], latitude_02: latOfPOI, longitude_02: longOfPOI, magVar: magVar)
                poiRangeOffBE = poiRandB.range
                poiBearingOffBE = poiRandB.bearing
            }}
        do {
            latLongOfPOI = try LatLon.parseLatLon(stringToParse: "\(latOfPOI)/\(longOfPOI)").toString(format: .degreesMinutes, decimalPlaces: 2)
            let ll = try LatLon.parseLatLon(stringToParse: "\(latOfPOI)/\(longOfPOI)")
            utmOfPOI = try ll.toUTM()
            mgrsOfPOI = try utmOfPOI?.toMGRS()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Mark Store
    @IBAction func listOfBullsEyesButton(_ sender: UIButton) {
        bullsEyeButtonOutlet.showPressed()
    }
    @IBAction func listOfMarkStoreButton(_ sender: UIButton) {
        storedFixesButtonOutlet.showPressed()
        let results = cdu.getMarkStore(pc: pc)
        print(results.count)
    }
    @IBAction func markStoreButton(_ sender: UIButton) {
        markPOI()
        let markPilotCoordsLat = Double(markPilotCoords.latitude)
        let markPilotCoordsLon = Double(markPilotCoords.longitude)
        cdu.addMarkStore(markBullseyeRefName: markBullseyeRefName,
                         markPilotAlt: markPilotAlt,
                         markPilotCoords: [markPilotCoordsLat, markPilotCoordsLon],
                         markPilotHeadingTrue: markPilotHeadingTrue,
                         markPilotHeadingMag: markPilotHeadingMag,
                         markMagVar: markMagVar,
                         markTime: markTime,
                         markBearingofPOItoBullsEye: markBearingofPOItoBullsEye,
                         markDistanceofPOItoBullsEye: markDistanceofPOItoBullsEye,
                         markPOICoords: markPOICoords,
                         markPOIUTM: markPOIUTM,
                         markPOIMGRS: markPOIMGRS,
                         pc: pc)
        setMarkCounter()
        storedFixesButtonOutlet.showPressed()
        markStoreButtonOutlet.showPressed()
    }
    
    @IBAction func exportToForeFlightButton(_ sender: UIButton) {
        exportToForeFlightButtonOutlet.showPressed()
        self.passToShareSheet(fileName: "MarkStore", ext: "kml", stringToWriteToFile: generateMarkStoreKML())
    }
    
    func generateMarkStoreKML() -> String {
        let listOfFixes = cdu.getMarkStore(pc: pc)
        var markStoreInternalKML = ""
        var markStoreCompleteKML = ""
        if listOfFixes.count != 0 {
            for fix in listOfFixes {
                
                func labelName() -> String {
                    let beName = "\(fix.markBullseyeRefName_CD ?? "")"
                    let bearingBE = "\(String(format: "%.0f",fix.markBearingofPOItoBullsEye_CD))°"
                    let distBE = "\(String(format: "%.0f",fix.markDistanceofPOItoBullsEye_CD))"
                    if fix.markBullseyeRefName_CD == "None Selected" {
                        let coords = "\(fix.markPOICoords_CD ?? "??")"
                        return coords
                    }
                    return "\(beName)::\(bearingBE)::\(distBE)"
                }
                
                let newName = labelName()
                let nameLabel = newName
                var placeMarkLocation: [Double] = []
                do {
                    let placeMarkLocationLatLon = try LatLon.parseLatLon(stringToParse: fix.markPOICoords_CD!)
                    let placeMarkLocationLat = LatLon.toDouble(placeMarkLocationLatLon)().lat
                    let placeMarkLocationLon = LatLon.toDouble(placeMarkLocationLatLon)().lon
                    placeMarkLocation.append(placeMarkLocationLon)
                    placeMarkLocation.append(placeMarkLocationLat)
                } catch {
                    print(error)
                }
                let internalKml = PlacemarkKML(placeMarkTitle: nameLabel,
                                               placeMarkDescription: "",
                                               placeMarkCoords: placeMarkLocation,
                                               iconType: .bluePin,
                                               withLabel: true,
                                               withIcon: true).iconGenerator()
                markStoreInternalKML += internalKml
            }
            markStoreCompleteKML = OpenCloseKML(kmlItems: markStoreInternalKML).KMLGenerator()
        } else {
            let alertController = UIAlertController(title: "No Stored Fixes", message:
                "You haven't taken any fixes, give it a shot on the little green button on the bottom right.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok, I'll give it a shot", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true)
        }
        return markStoreCompleteKML
    }
    
    func markPOI() {
        markBullseyeRefName = selectedBullsEye?.bullsEyeName_CD ?? "None Selected"
        markPilotAlt = 0.0
        markPilotCoords = locManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        markPilotHeadingTrue = locManager.heading?.trueHeading ?? 0.0
        markPilotHeadingMag = locManager.heading?.magneticHeading ?? 0.0
        markMagVar = Double(markPilotHeadingTrue - markPilotHeadingMag)
        markTime = Date()
        let markRandB = gonk.rangeAndBearing(latitude_01: selectedBullsEye?.centerPoint_CD?[0] ?? 0, longitude_01: selectedBullsEye?.centerPoint_CD?[1] ?? 0, latitude_02: latOfPOI, longitude_02: longOfPOI, magVar: magVar)
        markBearingofPOItoBullsEye = markRandB.bearing
        markDistanceofPOItoBullsEye = markRandB.range
        
        do {
            markPOICoords = try LatLon.parseLatLon(stringToParse: "\(latOfPOI)/\(longOfPOI)").toString(format: .degreesMinutes, decimalPlaces: 2)
            let ll = try LatLon.parseLatLon(stringToParse: markPOICoords)
            let markPOIUTM_ = try ll.toUTM()
            markPOIUTM = try ll.toUTM().toString(precision: 6)
            markPOIMGRS = try markPOIUTM_.toMGRS().toString(precision: 6)
        } catch {
            print(error)
        }
        let testStringToPrint = """
        BE Name: \(markBullseyeRefName)
        Pilot Coords: \(String(describing: markPilotCoords))
        Pilot True Heading: \(String(describing: markPilotHeadingTrue))
        Pilot Mag Heading: \(String(describing: markPilotHeadingMag))
        MagVar: \(markMagVar)
        Mark Time: \(markTime)
        POI Bearing to \(markBullseyeRefName): \(markBearingofPOItoBullsEye)
        POI Range to \(markBullseyeRefName): \(markDistanceofPOItoBullsEye)
        POI Coords: \(String(describing: markPOICoords))
        POI UTM: \(String(describing: markPOIUTM))
        POI MGRS: \(String(describing: markPOIMGRS))
        """
        print(testStringToPrint)
        
    }
    
    // MARK: - Location and Orientation
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingTrue = newHeading.trueHeading
        let headingMag = newHeading.magneticHeading
        magVar = headingTrue - headingMag
        switch orientationRawValue {
        case 1:
            self.headingOfDevice = headingTrue
            calculatePOI();updateDisplay()
        case 2:
            self.headingOfDevice = headingOrientationCorrection(180, trueHeading: headingTrue)
            calculatePOI();updateDisplay()
        case 3:
            self.headingOfDevice = headingOrientationCorrection(90, trueHeading: headingTrue)
            calculatePOI();updateDisplay()
        case 4:
            self.headingOfDevice = headingOrientationCorrection(270, trueHeading: headingTrue)
            calculatePOI();updateDisplay()
        default:
            print("Where'd the home button go?!?")
        }}
    
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
    
    func getOrientation(){
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motionData: CMDeviceMotion?, NSError) -> Void in self.outputRPY(data: motionData!)
            if (NSError != nil){
                //print("\(String(describing: NSError))")
            }})}
    
    func outputRPY(data: CMDeviceMotion){
        if let motion = motionManager.deviceMotion {
            let rpy = motion.attitude
            switch orientationRawValue {
            case 1:
                self.pitchAngleOfDevice = rpy.pitch
                self.rollOfDevice = rpy.roll
                self.yawOfDevice = rpy.yaw
            case 2:
                self.pitchAngleOfDevice = -1 * (rpy.pitch)
                self.rollOfDevice = -1 * (rpy.roll)
                self.yawOfDevice = rpy.yaw
            case 3:
                self.pitchAngleOfDevice = -1 * (rpy.roll)
                self.rollOfDevice = rpy.pitch
                self.yawOfDevice = rpy.yaw
            case 4:
                self.pitchAngleOfDevice = rpy.roll
                self.rollOfDevice = -1 * (rpy.pitch)
                self.yawOfDevice = rpy.yaw
            default:
                print("Where'd the home button go?!?")
            }}
            
        }
        
        
    
    func getPosition(){
        if let location = locManager.location {
            let latt = location.coordinate.latitude
            let long = location.coordinate.longitude
            let alt = location.altitude // in meters
            self.latOfDevice = latt
            self.longOfDevice = long
            self.altOfDevice = alt
        }}
    
    // TODO: - REMOVE FOR EXPORT
    func pilotAndBEViewFormatting () {
        let cr: CGFloat = 5
        let borderColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let borderWidth: CGFloat = 0
        let buttonCornerRadius: CGFloat = 10
        markButtonBlur.layer.cornerRadius = buttonCornerRadius
        bullsEyeButtonBlur.layer.cornerRadius = buttonCornerRadius
        storedPOIsBlur.layer.cornerRadius = buttonCornerRadius
        exportButtonBlur.layer.cornerRadius = buttonCornerRadius
        bullsEyeButtonOutlet.layer.cornerRadius = buttonCornerRadius
        storedFixesButtonOutlet.layer.cornerRadius = buttonCornerRadius
        markStoreButtonOutlet.layer.cornerRadius = buttonCornerRadius
        exportToForeFlightButtonOutlet.layer.cornerRadius = buttonCornerRadius
        for view in infoViews {
            view.layer.cornerRadius = cr
            view.layer.borderColor = borderColor
            view.layer.borderWidth = borderWidth
        }}
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let source = segue.source as? BullsEyeSelectedTableViewController
        let markStoreSource = segue.source as? MarkStoreListTableViewController
        if (markStoreSource?.markCounter) != nil {
            if markStoreSource?.shareCSV == true {
                if let csvString_ = UserDefaults.standard.object(forKey: "csvString") {
                    let csvString = csvString_ as! String
                    print(csvString)
                    self.passToShareSheet(fileName: "MarkStore", ext: "csv", stringToWriteToFile: csvString)
                }
            }
            
            setMarkCounter()
        }
        if let indexPathRowOfSelectedBE_ = (source?.indexPathRowOfSelectedBE) {
            indexPathRowOfSelectedBE = indexPathRowOfSelectedBE_
        }}
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "bullsEyePickerSeque"?:
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        case "markStoreListSegue":
            if let popoverPresentationController = segue.destination.popoverPresentationController, let sourceView = sender as? UIView {
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
    
    
    
}
