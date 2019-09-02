//
//  StringExtensions.swift
//  T38
//
//  Created by elmo on 5/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    public func removeSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).filter { $0 != Character(" ")}
    }
    
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeparator = formatter.decimalSeparator ?? "." //checks for localization
        
        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeparator)
            
            let digits = split.count == 2 ? split.last ?? "" : ""
            return digits.count <= maxDecimalPlaces
        }
        
        return false
    }
    
    
    func latitudeStringToDouble() -> Double {
        var lat = 0.0
        var a = self.split(separator: "-")
        let b = Double(a[0])!
        let c = Double(a[1])!/60.0
        let d = a[2]
        if d.contains("N") {
            let e = d.replacingOccurrences(of: "N", with: "")
            let f = Double(e)!/3600
            lat = b + c + f
        } else if d.contains("S") {
            let e = d.replacingOccurrences(of: "S", with: "")
            let f = Double(e)!/3600
            lat = -1 * (b + c + f)
        }
        return lat
    }
    func longitudeStringToDouble() -> Double {
        var long = 0.0
        var a = self.split(separator: "-")
        let b = Double(a[0])!
        let c = Double(a[1])!/60.0
        let d = a[2]
        if d.contains("E") {
            let e = d.replacingOccurrences(of: "E", with: "")
            let f = Double(e)!/3600
            long = b + c + f
        } else if d.contains("W") {
            let e = d.replacingOccurrences(of: "W", with: "")
            let f = Double(e)!/3600
            long = -1 * (b + c + f)
        }
        return long
    }
    
    // MARK: Coordinate Translator
    func coordinateTranslate() -> [Double] {
        let coordInput = self
        let coords = coordInput.capitalized
        var coordsArray = coords.components(separatedBy: "/")
        var lattitude: Double = 0.0
        var longitude = 0.0
        if coordsArray[0].range(of: "N") != nil {
            let lattitudeString = String(coordsArray[0].dropLast())
            lattitude = Double(lattitudeString)!
        } else {
            let lattitudeString = String(coordsArray[0].dropLast())
            lattitude = -1 * Double(lattitudeString)!
        }
        if coordsArray[1].range(of: "W") != nil {
            let longitudeString = String(coordsArray[1].dropLast())
            longitude = -1 * Double(longitudeString)!
        } else {
            let longitudeString = String(coordsArray[1].dropLast())
            longitude = Double(longitudeString)!
        }
        let coordCalculatedArray: Array = [lattitude,longitude]
        return coordCalculatedArray
    }
    // MARK: A Better Coordinate Translator
    /*
     It can handle all of the following formats and returns an Array of Doubles
     [latitude, longitude]
     // MARK: DD°MM.dd
     "S3743.15/W12123.15"
     "s3743.15/w12123.15"
     "3743.15N/12123.15W"
     "3743.15n/12123.15w"
     "3743.15/-12123.15"
     "N3743.15 W12123.15"
     "n3743.15 w12123.15"
     "3743.15N 12123.15W"
     "3743.15n 12123.15w"
     "-3743.15 -12123.15"
     
     // MARK: DD.dddd
     "N37.4315/e121.2315"
     "s37.4315/w121.2315"
     "37.4315N/121.2315W"
     "37.4315n/121.2315w"
     "37.4315/-121.2315"
     "N37.4315 W121.2315"
     "n37.4315 w121.2315"
     "37.4315N 121.2315W"
     "37.4315n 121.2315w"
     "-37.4315 -121.2315"
     
     
     The following formats are acceptable:
     NDD°MM.dd/WDDD°MM.dd
     DD°MM.ddN/DDD°MM.ddW
     nDD°MM.dd/wDDD°MM.dd
     DD°MM.ddn/DDD°MM.ddw
     -DD°MM.dd/-DDD°MM.dd
     
     NDD°MM.dd WDDD°MM.dd
     DD°MM.ddN DDD°MM.ddW
     nDD°MM.dd wDDD°MM.dd
     DD°MM.ddn DDD°MM.ddw
     -DD°MM.dd -DDD°MM.dd
     
     NDD.dddd/WDDD.dddd
     DD.ddddN/DDD.ddddW
     nDD.dddd/wDDD.dddd
     DD.ddddn/DDD.ddddw
     -DD.dddd/-DDD.dddd
     
     NDD.dddd WDDD.dddd
     DD.ddddN DDD.ddddW
     nDD.dddd wDDD.dddd
     DD.ddddn DDD.ddddw
     -DD.dddd -DDD.dddd
     */
    
    public func latitudeTranslate() -> Double {
        let latString = self
        var latDouble: Double = 0.0
        func coordLatConvert(coord: Double) -> Double {
            var result = 0.0
            if coord < 0.0 {
                if abs(coord) > 90.0 {
                    let degrees = floor(abs(coord/100))
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0 * -1
                    result = (degrees + decimalDegrees) * -1
                } else {
                    result = coord
                }
            } else {
                if abs(coord) > 90.0 {
                    let degrees = floor(coord/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0
                    result = degrees + decimalDegrees
                } else {
                    result = coord
                }
            }
            return result
        }

        if latString.contains("N") {
            let a = Double(latString.replacingOccurrences(of: "N", with: ""))!
            latDouble = coordLatConvert(coord: a)
        } else if latString.contains("S") {
            let a = Double(latString.replacingOccurrences(of: "S", with: ""))!
            latDouble = coordLatConvert(coord: a) * (-1)
        } else {
            let a = Double(String(latString))!
            latDouble = coordLatConvert(coord: a)
        }
        return latDouble
    }
    
    public func longitudeTranslate() -> Double {
        let longString = self
        var longDouble: Double = 0.0
        func coordLongConvert(coord: Double) -> Double {
            var result = 0.0
            if coord < 0.0 {
                if abs(coord) > 180.0 {
                    let degrees = floor(abs(coord)/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0 * -1
                    result = (degrees + decimalDegrees) * -1
                } else {
                    result = coord
                }
            } else {
                if abs(coord) > 180.0 {
                    let degrees = floor(abs(coord)/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0
                    result = degrees + decimalDegrees
                } else {
                    result = coord
                }
            }
            return result
        }
        
        if longString.contains("E") {
            let a = Double(longString.replacingOccurrences(of: "E", with: ""))!
            longDouble = coordLongConvert(coord: a)
        } else if longString.contains("W") {
            let a = Double(longString.replacingOccurrences(of: "W", with: ""))!
            longDouble = coordLongConvert(coord: a) * (-1)
        } else {
            let a = Double(String(longString))!
            longDouble = coordLongConvert(coord: a)
        }
        return longDouble
    }
    
    
    
    
    
    
    
    
    
    
    
    public func coordTranslate() -> [Double] {
        let coords = self
        let latDouble: Double
        let longDouble: Double
        var coordArray = [Double]()
        func coordLatConvert(coord: Double) -> Double {
            var result = 0.0
            if coord < 0.0 {
                if abs(coord) > 90.0 {
                    let degrees = floor(abs(coord/100))
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0 * -1
                    result = (degrees + decimalDegrees) * -1
                } else {
                    result = coord
                }
            } else {
                if abs(coord) > 90.0 {
                    let degrees = floor(coord/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0
                    result = degrees + decimalDegrees
                } else {
                    result = coord
                }
            }
            return result
        }
        func coordLongConvert(coord: Double) -> Double {
            var result = 0.0
            if coord < 0.0 {
                if abs(coord) > 180.0 {
                    let degrees = floor(abs(coord)/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0 * -1
                    result = (degrees + decimalDegrees) * -1
                } else {
                    result = coord
                }
            } else {
                if abs(coord) > 180.0 {
                    let degrees = floor(abs(coord)/100)
                    let decimalDegrees = coord.truncatingRemainder(dividingBy: 100.0)/60.0
                    result = degrees + decimalDegrees
                } else {
                    result = coord
                }
            }
            return result
        }
        if coords.contains("/") {
            let latString = coords.split(separator: "/")[0].uppercased()
            if latString.contains("N") {
                latDouble = Double(latString.replacingOccurrences(of: "N", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble))
            } else if latString.contains("S") {
                latDouble = Double(latString.replacingOccurrences(of: "S", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble) * (-1))
            } else {
                latDouble = Double(String(latString))!
                coordArray.append(coordLatConvert(coord: latDouble))
            }
            
            let longString = coords.split(separator: "/")[1].uppercased()
            if longString.contains("E") {
                longDouble = Double(longString.replacingOccurrences(of: "E", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble))
            } else if longString.contains("W") {
                longDouble = Double(longString.replacingOccurrences(of: "W", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble) * (-1))
            } else {
                longDouble = Double(String(longString))!
                coordArray.append(coordLongConvert(coord: longDouble))
            }
        } else if coords.contains(" ") {
            let latString = coords.split(separator: " ")[0].uppercased()
            if latString.contains("N") {
                latDouble = Double(latString.replacingOccurrences(of: "N", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble))
            } else if latString.contains("S") {
                latDouble = Double(latString.replacingOccurrences(of: "S", with: ""))!
                coordArray.append(coordLatConvert(coord: latDouble) * (-1))
            } else {
                latDouble = Double(String(latString))!
                coordArray.append(coordLatConvert(coord: latDouble))
            }
            
            let longString = coords.split(separator: " ")[1].uppercased()
            if longString.contains("E") {
                longDouble = Double(longString.replacingOccurrences(of: "E", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble))
            } else if longString.contains("W") {
                longDouble = Double(longString.replacingOccurrences(of: "W", with: ""))!
                coordArray.append(coordLongConvert(coord: longDouble) * (-1))
            } else {
                longDouble = Double(String(longString))!
                coordArray.append(coordLongConvert(coord: longDouble))
            }
        } else {
            //Insert Alert Here for improper format
            print("nope")
        }
        print(coordArray)
        return coordArray
    }
    
    public func jsonCoordProcessing() -> String {
        let coordInput = self
        var coords = ""
        var coordPartArray = coordInput.components(separatedBy: "-")
        let DD = Double(coordPartArray[0])
        let MM = Double(coordPartArray[1])!/60
        let SS = Double(coordPartArray[2].dropLast())!/60/100
        let NSEW = coordPartArray[2].removeLast()
        let DDmmss = "\(NSEW)\(String(DD! + MM + SS))"
        coords = "\(DDmmss)"
        print(coords)
        return coords
    }
    
    public func importFlightPlanFromForeflight() -> [String:String] {
        let clipBaord = "Clip Board"
        var importAll = [String:String]()
        let foreflightFlightPlan = self
        var latLong = foreflightFlightPlan.split(separator: " ")
        let positionOfFFAltitudeString = latLong.count - 1
        latLong.remove(at: positionOfFFAltitudeString)
        var coordString = ""
        for latlongs in latLong {
            let x = String(latlongs)
            let lat = x.coordTranslate()[0]
            let long = x.coordTranslate()[1]
            coordString += "\(long),\(lat),500\r"
        }
        importAll[clipBaord] = coordString
        return importAll
    }
    
    
    public func switchCodeToImage() -> String {
        var colorImageName = ""
        switch self {
        case "000000":
            colorImageName = "Black"
        case "1400FF":
            colorImageName = "Red"
        case "1478FF":
            colorImageName = "Orange"
        case "14B4FF":
            colorImageName = "LightYellow"
        case "147800":
            colorImageName = "DarkGreen"
        case "780014":
            colorImageName = "Blue"
        default:
            print("NOPE")
        }
        return colorImageName
    }
    
    public func switchColorImageToCode() -> String {
        var color = ""
        switch self {
        case "Black":
            color = "000000"
        case "Red":
            color = "1400FF"
        case "Orange":
            color = "1478FF"
        case "LightYellow":
            color = "14B4FF"
        case "DarkGreen":
            color = "147800"
        case "Blue":
            color = "780014"
        default:
            print("NOPE")
        }
        return color
    }
    
    
    public func switchIcon() -> String {
        var icon = ""
        switch self {
        case " ":
            icon = " "
        case "http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png":
            icon = "yellowPin"
        case "http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin.png":
            icon = "bluePin"
        case  "http://maps.google.com/mapfiles/kml/pushpin/grn-pushpin.png":
            icon = "greenPin"
        case "http://maps.google.com/mapfiles/kml/pushpin/ltblu-pushpin.png":
            icon = "lightBluePin"
        case  "http://maps.google.com/mapfiles/kml/pushpin/pink-pushpin.png":
            icon = "pinkPin"
        case  "http://maps.google.com/mapfiles/kml/pushpin/purple-pushpin.png":
            icon = "purplePin"
        case  "http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png":
            icon = "whitePin"
        case  "http://maps.google.com/mapfiles/kml/paddle/blu-diamond.png":
            icon = "blueCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/blu-circle.png":
            icon = "blueCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/shapes/placemark_square.png":
            icon = "blueCircleSquare"
        case  "http://maps.google.com/mapfiles/kml/paddle/grn-diamond.png":
            icon = "greenDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/grn-circle.png":
            icon = "greenCircle"
        case "http://maps.google.com/mapfiles/kml/paddle/grn-square.png":
            icon = "greenSquare"
        case  "http://maps.google.com/mapfiles/kml/paddle/ltblu-diamond.png":
            icon = "lightBlueCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/ltblu-circle.png":
            icon = "lightBlueCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/paddle/ltblu-square.png":
            icon = "lightBlueCircleSquare"
        case  "http://maps.google.com/mapfiles/kml/paddle/pink-diamond.png":
            icon = "pinkCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/pink-circle.png":
            icon = "pinkCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/paddle/pink-square.png":
            icon = "pinkCircleSquare"
        case  "http://maps.google.com/mapfiles/kml/paddle/ylw-diamond.png":
            icon = "yellowCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/ylw-circle.png":
            icon = "yellowCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/paddle/ylw-square.png":
            icon = "yellowCircleSquare"
        case  "http://maps.google.com/mapfiles/kml/paddle/wht-diamond.png":
            icon = "whiteCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/wht-circle.png":
            icon = "whiteCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/paddle/red-diamond.png":
            icon = "redCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/red-circle.png":
            icon = "redCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/paddle/red-square.png":
            icon = "redCircleSquare"
        case  "http://maps.google.com/mapfiles/kml/paddle/purple-diamond.png":
            icon = "purpleCircleDiamond"
        case  "http://maps.google.com/mapfiles/kml/paddle/purple-circle.png":
            icon = "purpleCircleCircle"
        case  "http://maps.google.com/mapfiles/kml/paddle/purple-square.png":
            icon = "purpleCircleSquare"
        case  "http://maps.google.com/mapfiles/kml/shapes/open-diamond.png":
            icon = "openDiamond"
        case  "http://maps.google.com/mapfiles/kml/shapes/target.png":
            icon = "targetBlue"
        case  "http://maps.google.com/mapfiles/kml/shapes/triangle.png":
            icon = "blueTriangle"
        case  "http://maps.google.com/mapfiles/kml/shapes/forbidden.png":
            icon = "forbidden"
        case  "http://maps.google.com/mapfiles/kml/paddle/wht-square.png":
            icon = "whiteCircleSquare"
        case  "":
            icon = "orangeCircle"
        default:
            print("Not gunna happen")
        }
        return icon
    }
    
    public func switchIconImageNameToHref() -> String {
        var icon = ""
        switch self {
        case "none":
            icon = " "
        case "yellowPin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png"
        case "bluePin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin.png"
        case "greenPin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/grn-pushpin.png"
        case "lightBluePin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/ltblu-pushpin.png"
        case "pinkPin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/pink-pushpin.png"
        case "purplePin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/purple-pushpin.png"
        case "whitePin":
            icon = "http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png"
        case "blueCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/blu-diamond.png"
        case "blueCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/blu-circle.png"
        case "blueCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/shapes/placemark_square.png"
        case "greenDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/grn-diamond.png"
        case "greenCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/grn-circle.png"
        case "greenSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/grn-square.png"
        case "lightBlueCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/ltblu-diamond.png"
        case "lightBlueCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/ltblu-circle.png"
        case "lightBlueCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/ltblu-square.png"
        case "pinkCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/pink-diamond.png"
        case "pinkCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/pink-circle.png"
        case "pinkCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/pink-square.png"
        case "yellowCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/ylw-diamond.png"
        case "yellowCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/ylw-circle.png"
        case "yellowCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/ylw-square.png"
        case "whiteCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/wht-diamond.png"
        case "whiteCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/wht-circle.png"
        case "redCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/red-diamond.png"
        case "redCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/red-circle.png"
        case "redCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/red-square.png"
        case "purpleCircleDiamond":
            icon = "http://maps.google.com/mapfiles/kml/paddle/purple-diamond.png"
        case "purpleCircleCircle":
            icon = "http://maps.google.com/mapfiles/kml/paddle/purple-circle.png"
        case "purpleCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/purple-square.png"
        case "openDiamond":
            icon = "http://maps.google.com/mapfiles/kml/shapes/open-diamond.png"
        case "targetBlue":
            icon = "http://maps.google.com/mapfiles/kml/shapes/target.png"
        case "blueTriangle":
            icon = "http://maps.google.com/mapfiles/kml/shapes/triangle.png"
        case "forbidden":
            icon = "http://maps.google.com/mapfiles/kml/shapes/forbidden.png"
        case "whiteCircleSquare":
            icon = "http://maps.google.com/mapfiles/kml/paddle/wht-square.png"
        case "orangeCircle":
            icon = ""
        default: print("")
        }
        return icon
    }
    
    public func getCGColor() -> CGColor {
        switch self {
        case "000000":
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case "1400FF":
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case "1478FF":
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        case "14B4FF":
            return #colorLiteral(red: 0.7757097483, green: 0.7970964313, blue: 0, alpha: 1)
        case "14F0FF":
            return #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        case "147800":
            return #colorLiteral(red: 0.06467383355, green: 0.5053943992, blue: 0.05583944172, alpha: 1)
        case "14F000":
            return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case "780014":
            return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        default:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func getUIColor() -> UIColor {
        switch self {
        case "000000":
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case "1400FF":
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case "1478FF":
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        case "14B4FF":
            return #colorLiteral(red: 0.7757097483, green: 0.7970964313, blue: 0, alpha: 1)
        case "14F0FF":
            return #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        case "147800":
            return #colorLiteral(red: 0.06467383355, green: 0.5053943992, blue: 0.05583944172, alpha: 1)
        case "14F000":
            return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case "780014":
            return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        default:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func getAlpha() -> CGFloat {
        switch self {
        case "0":
            return 0.0
        case "5":
            return 0.05
        case "a":
            return 0.10
        case "f":
            return 0.15
        case "14":
            return 0.2
        case "19":
            return 0.25
        case "1e":
            return 0.3
        case "23":
            return 0.35
        case "28":
            return 0.4
        case "2d":
            return 0.45
        case "32":
            return 0.5
        case "37":
            return 0.55
        case "3c":
            return 0.6
        case "41":
            return 0.65
        case "46":
            return 0.7
        case "4b":
            return 0.75
        case "50":
            return 0.8
        case "55":
            return 0.85
        case "5a":
            return 0.9
        case "5f":
            return 0.95
        case "ff":
            return 1
        default:
            return 0.0
        }}
    
    
    func substring(from: Int, to: Int) -> String {
        var stringReturn = self
        let start = index(startIndex, offsetBy: from)
        if to > self.count {
            stringReturn = self
        } else {
            let end = index(start, offsetBy: to - from)
            if end < start {
                return self
            } else {
                stringReturn = String(self[start ..< end])
            } 
        }
        return stringReturn
    }
    
    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
