//
//  Calculations_.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 8/19/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit
import Darwin

struct Calculations {
    private let majEarthAxis_WGS84: Double = 6_378_137.0                // maj      - meters
    private let minEarthAxis_WGS84: Double = 6_356_752.314_245          // min      - meters
    
    
    func poiCalc(deviceLat: Double,
                 deviceLong: Double,
                 deviceAlt: Double,
                 devicePitch: Double,
                 deviceRoll: Double,
                 deviceHdgTrue: Double) -> (poiLat: Double, poiLong: Double, poiDist: Double) {
        
        var devicePitch = devicePitch
        var deviceRoll = deviceRoll
        if devicePitch == 0.0 {
            devicePitch = 0.01
        }
        if deviceRoll == 0.0 {
            deviceRoll = 0.01
        }
        
        var headingCorrection: Double {
            let num = tan(deviceRoll)
            let den = cos((.pi/2) - devicePitch)
            return atan(num/den).radiansToDegrees
        }
        
        var pitchCorrected: Double {
            let num = sin(deviceRoll)
            let den = sin(headingCorrection.degreesToRadians)
            let a = acos(num/den).radiansToDegrees
            return (90 - a).degreesToRadians
        }
        
        //1: radiusCorrectionFactor()
        let a1 = 1.0/(self.majEarthAxis_WGS84*self.majEarthAxis_WGS84)
        let b1 = (tan(deviceLat.degreesToRadians)*tan(deviceLat.degreesToRadians)) / (self.minEarthAxis_WGS84*self.minEarthAxis_WGS84)
        let c1 = 1.0/((a1+b1).squareRoot())
        let d1 = c1/(cos(deviceLat.degreesToRadians))
        
        //2: centralAngleSolver()
        let a2 = d1 + deviceAlt
        let b2 = sin(pitchCorrected)/d1
        let c2 = .pi - asin(a2*b2)
        let d2 = (180 - (pitchCorrected.radiansToDegrees + c2.radiansToDegrees)).degreesToRadians
        
        //3: distanceSolver()
        let a3 = (d1*d2).metersToNauticalMiles
        let b3 = a3/60
        print(b3)
        
        //5: coordinate for POI solver
        let a5 = (90-(deviceHdgTrue - headingCorrection)).degreesToRadians
        let poiLat = (b3*sin(a5))+deviceLat
        let poiLong = ((b3/cos(deviceLat.degreesToRadians))*cos(a5))+deviceLong
        
        return (poiLat: poiLat, poiLong: poiLong, poiDist: a3)
    }
    
    
    public func rangeAndBearing(latitude_01: Double,
                                longitude_01: Double,
                                latitude_02: Double,
                                longitude_02: Double,
                                magVar: Double) -> (range: Double, bearing: Double) {
        let lat_01 = latitude_01.degreesToRadians
        let lat_02 = latitude_02.degreesToRadians
        let long_01 = longitude_01.degreesToRadians
        let long_02 = longitude_02.degreesToRadians
        let difLong = (longitude_02 - longitude_01).degreesToRadians
        //1: radiusCorrectionFactor()
        let a1 = 1.0/(self.majEarthAxis_WGS84 * self.majEarthAxis_WGS84)
        let b1 = (tan(lat_01) * tan(lat_01)) / (self.minEarthAxis_WGS84 * self.minEarthAxis_WGS84)
        let c1 = 1.0/((a1+b1).squareRoot())
        let d1 = c1/(cos(lat_01))
        //2: Law of Cosines
        let range = (acos(sin(lat_01)*sin(lat_02) + cos(lat_01)*cos(lat_02) * cos(difLong)) * d1).metersToNauticalMiles
        //3: Calculating Bearing from 1st coords to 2nd
        let a3 = sin(long_02 - long_01) * cos(lat_02)
        let b3 = cos(lat_01) * sin(lat_02) - sin(lat_01) * cos(lat_02) * cos(long_02 - long_01)
        var bearing = ((atan2(a3, b3).radiansToDegrees) + 360).truncatingRemainder(dividingBy: 360) - magVar
        
        if bearing >= 360 {
            bearing -= 360
        }
        if bearing < 0 {
            bearing += 360
        }
        
        return (range: range, bearing: bearing)
    }
    
}
