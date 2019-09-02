//
//  Supporting.swift
//  DragonCalculations
//
//  Created by Matthew Elmore on 8/3/18.
//  Copyright © 2018 Matthew Elmore. All rights reserved.
//

import Foundation

//precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
//infix operator ^ : PowerPrecedence
//func ^ (radix: Double, power: Double) -> Double {
//    return Double(pow(Double(radix), Double(power)))
//}


// MARK: - Extensions
public extension Formatter {
    static let avoidNotation: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

public extension Double {
    var avoidNotation: String {
        return Formatter.avoidNotation.string(for: self) ?? ""
    }
}

public enum FuelLoad: Double {
    case R0 = 588
    case R1 = 688
    case R2 = 888
    case R3 = 1088
    case R4 = 1388
    case R5 = 1588
    case R6 = 1788
    case R7 = 1988
    case R8 = 2188
    case R9 = 2388
    case R10 = 2588
    case R11 = 2788
    case R12 = 2950
}

public enum RunwayCondition {
    case dry
    case wet
    case snow
    case ice
}

// MARK: - Glide Stuff
public enum Configuration: Double {
    case slickGearUp = 37.0
    case slickGearDown = 31.0
    case superPodsGearUp = 34.0
    case superPodsGearDown = 29.0
    case pegGearUp = 32.0
    case pegGearDown = 27.0
}

public enum Corrections: Double {
    case none = 0.0
    case gustUp = -1.0
    case speedBrakeOutGearUp = -10.0
    case speedBrakeOutGearDown = -8.0
    case spoilersUpGearUp = -15.00001 //the extended decimal is nominal and just to make the enum have unique raw values
    case spoilersUpGearDown = -12.0
    case spoilersUpAndSpeedBrakeOutGearUp = -18.0
    case spoilersUpAndSpeedBrakeOutGearDown = -15.00002 //the extended decimal is nominal and just to make the enum have unique raw values
}

