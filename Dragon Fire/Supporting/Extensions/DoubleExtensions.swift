//
//  DoubleExtensions.swift
//  T38
//
//  Created by elmo on 5/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit


public extension Double {
    //http://www.kylesconverter.com
    var radiansToDegrees: Double { return self * 180 / Double.pi }
    var degreesToRadians: Double { return self * Double.pi / 180 }
    var metersToFeet: Double { return self * 3.2808399 }
    var feetToMeters: Double { return self * 0.3048 }
    var metersToNauticalMiles: Double { return self * 0.0005396118248380001 }
    var nauticalMilesToMeters: Double { return self * 1852 }
    var nauticalMilesToFeet: Double { return self * 6076 }
    
    
    func numberOfDecimalPlaces(_ decimalPlaces: Int) -> Double {
        let numberOfDecimalPlaces = String(decimalPlaces)
        let returnDouble = Double("\(String(format: "%.\(numberOfDecimalPlaces)f", self))")
        return returnDouble!
    }
   
    
    public func lat_DDdddd_To_DDMMdd() -> String {
        let lat = self
        let degPart = floor(Double.abs(lat))
        let decimalPart = Double.abs(lat).truncatingRemainder(dividingBy: 1)
        let MMdd = decimalPart * 60
        var MMddProper = ""
        if MMdd < 10 {
            MMddProper = "0\(String(format: "%.2f", MMdd))"
        } else {
            MMddProper = String(format: "%.2f", MMdd)
        }
        var northOrSouth = ""
        if lat < 0 {
            northOrSouth = "S"
        } else {
            northOrSouth = "N"
        }
        let coordReturn = "\(Int(degPart))°\(MMddProper) \(northOrSouth)"
        return coordReturn
    }
    
    public func long_DDdddd_To_DDMMdd() -> String {
        let long = self
        let degPart = floor(Double.abs(long))
        let decimalPart = Double.abs(long).truncatingRemainder(dividingBy: 1)
        let MMdd = decimalPart * 60
        var MMddProper = ""
        if MMdd < 10 {
            MMddProper = "0\(String(format: "%.2f", MMdd))"
        } else {
            MMddProper = String(format: "%.2f", MMdd)
        }
        var eastOrWest = ""
        if long < 0 {
            eastOrWest = "W"
        } else {
            eastOrWest = "E"
        }
        let coordReturn = "\(Int(degPart))°\(MMddProper) \(eastOrWest)"
        return coordReturn
    }
    
    static func ^(lhs: Double, rhs: Double) -> Double{
        return pow(lhs, rhs)
    }

}
