////
////  Calculation.swift
////  Dragon Fire
////
////  Created by Matthew Elmore on 8/9/18.
////  Copyright © 2018 elmo. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Darwin
//
//
//struct Calculation {
//    
//    var latitudeAngleOfDevice: Double = 0.0                     // 𝜙 (1)    - degrees
//    var longitudeAngleOfDevice: Double = 0.0                    // λ (1)    - degrees
//    var altitudeOfDevice: Double = 0.0                          // ζ        - meters
//    var pitchAngleOfTheDevice: Double = 0.0                     // β        - degrees
//    let majEarthAxis_WGS84: Double = 6_378_137.0                // maj      - meters
//    let minEarthAxis_WGS84: Double = 6_356_752.314_245          // min      - meters
//    var earthRadiusCalculated: Double = 0.0                     // x        - meters
//    var cSideOfTraingleCalculated: Double = 0.0                 // c        - meters
//    var headingAngleOfTheDevice_TN: Double = 0.0                // 𝜃        - degrees
//    var centralAngleBetweenCalculated: Double = 0.0             // α        - radians??
//    var distanceToPOICalculated: Double = 0.0                   // d        - meters??
//    var lattitudeAngleOfPOI: Double = 0.0                       //
//    var longitudeAngleOfPOI: Double = 0.0                       //
//    
//    mutating func coordsOfPOICalculate(latitudeAngleOfDevice: Double, longitudeAngleOfDevice: Double, altitudeOfDevice: Double, pitchAngleOfTheDevice: Double, headingAngleOfTheDevice_TN: Double) -> (lat: Double, long: Double, alt: Double) {
//        //Local Variable names in initializer functions are just placeholders to more easily break up the correction equations
//        //1: radiusCorrectionFactor()
//        let a1 = 1.0/(self.majEarthAxis_WGS84*self.majEarthAxis_WGS84)
//        let b1 = (tan(latitudeAngleOfDevice.degreesToRadians)*tan(latitudeAngleOfDevice.degreesToRadians)) / (self.minEarthAxis_WGS84*self.minEarthAxis_WGS84)
//        let c1 = 1.0/((a1+b1).squareRoot())
//        let d1 = c1/(cos(latitudeAngleOfDevice.degreesToRadians))
//        
//        
//        //2: centralAngleSolver()
//        let a2 = d1 + altitudeOfDevice
//        let b2 = sin(pitchAngleOfTheDevice)/d1
//        let c2 = Double.pi - asin(a2*b2)
//        let d2 = (180 - (pitchAngleOfTheDevice.radiansToDegrees + c2.radiansToDegrees)).degreesToRadians
//        
//        //3: distanceSolver()
//        let a3 = (d1*d2).metersToNauticalMiles
//        let b3 = a3/60
//        
//        //5: coordinate for POI solver
//        let a5 = (90-headingAngleOfTheDevice_TN).degreesToRadians
//        let lattitudeAngleOfPOI = (b3*sin(a5))+latitudeAngleOfDevice
//        let longitudeAngleOfPOI = ((b3/cos(latitudeAngleOfDevice.degreesToRadians))*cos(a5))+longitudeAngleOfDevice
//        
//        self.latitudeAngleOfDevice = latitudeAngleOfDevice
//        self.longitudeAngleOfDevice = longitudeAngleOfDevice
//        self.altitudeOfDevice = altitudeOfDevice
//        self.pitchAngleOfTheDevice = pitchAngleOfTheDevice
//        self.earthRadiusCalculated = d1
//        self.centralAngleBetweenCalculated = d2
//        self.cSideOfTraingleCalculated = a2
//        self.distanceToPOICalculated = a3
//        self.lattitudeAngleOfPOI = lattitudeAngleOfPOI
//        self.longitudeAngleOfPOI = longitudeAngleOfPOI
//        return (lat: lattitudeAngleOfPOI, long: longitudeAngleOfPOI, alt: a3)
//    }
//    
//    public func rangeAndBearing(latitude_01: Double, longitude_01: Double, latitude_02: Double, longitude_02: Double, magVar: Double) -> [Double] {
//        let majEarthAxis_WGS84: Double = 6_378_137.0                // maj      - meters
//        let minEarthAxis_WGS84: Double = 6_356_752.314_245          // min      - meters
//        let lat_01 = latitude_01.degreesToRadians
//        let lat_02 = latitude_02.degreesToRadians
//        let long_01 = longitude_01.degreesToRadians
//        let long_02 = longitude_02.degreesToRadians
//        let difLong = (longitude_02 - longitude_01).degreesToRadians
//        //1: radiusCorrectionFactor()
//        let a1 = 1.0/(majEarthAxis_WGS84 * majEarthAxis_WGS84)
//        let b1 = (tan(lat_01) * tan(lat_01)) / (minEarthAxis_WGS84 * minEarthAxis_WGS84)
//        let c1 = 1.0/((a1+b1).squareRoot())
//        let d1 = c1/(cos(lat_01))
//        //2: Law of Cosines
//        let range = (acos(sin(lat_01)*sin(lat_02) + cos(lat_01)*cos(lat_02) * cos(difLong)) * d1).metersToNauticalMiles
//        //3: Calculating Bearing from 1st coords to second
//        let a3 = sin(long_02 - long_01) * cos(lat_02)
//        let b3 = cos(lat_01) * sin(lat_02) - sin(lat_01) * cos(lat_02) * cos(long_02 - long_01)
//        let bearing = ((atan2(a3, b3).radiansToDegrees) + 360).truncatingRemainder(dividingBy: 360) - magVar
//        let results = [range, bearing]
//        print(range)
//        return results
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
