//: Playground - noun: a place where people can play

import UIKit
struct EngineOut {
    private var currentAlt = 0.0 //ipad gives alt in meters
    private var ktJet = 0.0
    private var fuelRemaining = 100.0  //Gallons
    private var config: Configuration = .slickGearUp
    private var correction: Corrections = .none
    private var currentWeight: Double = 0.0
    
    init(currentAlt: Double,
         ktJet: Double,
         fuelRemaining: Double,
         config: Configuration,
         correction: Corrections) {
        self.currentAlt = currentAlt
        self.ktJet = ktJet
        self.fuelRemaining = fuelRemaining
        self.currentWeight  = self.totalCurrentWeight()
        self.config = config
        self.correction = correction
    }
    
    enum Configuration: Double {
        case slickGearUp = 37.0
        case slickGearDown = 31.0
        case superPodsGearUp = 34.0
        case superPodsGearDown = 29.0
        case pegGearUp = 32.0
        case pegGearDown = 27.0
    }
    
    enum Corrections: Double {
        case none = 0.0
        case gustUp = -1.0
        case speedBrakeOutGearUp = -10.0
        case speedBrakeOutGearDown = -8.0
        case spoilersUpGearUp = -15.00001 //the extended decimal is nominal and just to make the enum have unique raw values
        case spoilersUpGearDown = -12.0
        case spoilersUpAndSpeedBrakeOutGearUp = -18.0
        case spoilersUpAndSpeedBrakeOutGearDown = -15.00002 //the extended decimal is nominal and just to make the enum have unique raw values
    }
    
    public func glideDistance() -> Double {
        let altAdj = self.currentAlt / 10000
        let glideFactor = config.rawValue + correction.rawValue
        let result = glideFactor*altAdj
        return result
    }
    
    private func totalCurrentWeight() -> Double {
        let zfw = 18700.0
        let gasWeight = 6.5 //per gallon
        let jet = (self.ktJet * 650.0) + zfw
        let fuelWeight = gasWeight * self.fuelRemaining
        let totalWeight = jet + fuelWeight
        return totalWeight
    }
    
    public func altLossAt_20_DegreesAngleOfBankFor(degrees: Double) -> Double {
        let altFor180 = (0.0144*self.currentWeight) + 78 //Extrapolated using Excel (Linear Formula) and Figure 3-2 in -1
        let altPerDegree = altFor180/180
        let alt = altPerDegree * degrees
        return alt
    }
    
    public func altLossAt_30_DegreesAngleOfBankFor(degrees: Double) -> Double {
        let altFor180 = (0.0104*self.currentWeight) + 50 //Extrapolated using Excel (Linear Formula) and Figure 3-2 in -1
        let altPerDegree = altFor180/180
        let alt = altPerDegree * degrees
        return alt
    }
    
    public func timeForTurnAt_20_DegreesAngleOfBankFor(degrees: Double) -> Double {
        let timeFor180 = (0.0007*self.currentWeight) + 28.8 //Extrapolated using Excel (Linear Formula) and Figure 3-2 in -1
        let timePerDegree = timeFor180/180
        let alt = timePerDegree * degrees
        return alt
    }
    
    public func timeForTurnAt_30_DegreesAngleOfBankFor(degrees: Double) -> Double {
        let timeFor180 = (0.0004*self.currentWeight) + 17.6 //Extrapolated using Excel (Linear Formula) and Figure 3-2 in -1
        let timePerDegree = timeFor180/180
        let alt = timePerDegree * degrees
        return alt
    }
    
    public func altLossAfter30SecondsOfTurnAt_20_DegreesAngleOfBankFor(degrees: Double) -> Double {
        let timeFor180 = (0.0046*self.currentWeight) + 176 //Extrapolated using Excel (Linear Formula) and Figure 3-2 in -1
        let timePerDegree = timeFor180/180
        let alt = timePerDegree * degrees
        return alt
    }
    
    public func altLossAfter30SecondsOfTurnAt_30_DegreesAngleOfBankFor(degrees: Double) -> Double {
        let timeFor180 = (0.0056*self.currentWeight) + 180 //Extrapolated using Excel (Linear Formula) and Figure 3-2 in -1
        let timePerDegree = timeFor180/180
        let alt = timePerDegree * degrees
        return alt
    }
    
    public func altLossCorrectionFactorPer1000FtAboveSeaLevel(alt: Double) -> Double {
        return alt * 1.03
    }
    
    public func altLossCorrectionFactorForEachDegreeCelciusAboveStandardDay(tempDev: Double) -> Double {
        return tempDev * 1.003 //-1 says 3% for each 10°, this is taken down to 1°
    }
    
    public func minSinkAirspeedWithFuel(_ gal: Double, ktJet: Double) -> Double {
        return gal/100 + 90 + ktJet
    }
    
    public func bestGlideAirspeedWithFuel(_ gal: Double, ktJet: Double) -> Double {
        return gal/100 + 105 + ktJet
    }
    
}


//let newSit = EngineOut(currentAlt: 70000,
//                       ktJet: 4.0,
//                       fuelRemaining: 1400,
//                       config: .slickGearUp,
//                       correction: .none)
//
//print(newSit.altLossAt_20_DegreesAngleOfBankFor(degrees: 180))
//print(newSit.glideDistance())

var coordString =  """
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        123.44/-123.32
                        """


func getCoordsFromTextView(_ coordString: String?) -> [[Double]]{
    var returnArray: [[Double]] = []
    if let coordInput = coordString {
        let latLongString00 = coordInput.trimmingCharacters(in: .whitespacesAndNewlines).filter { $0 != Character(" ")}
        let latLongString01 = latLongString00.components(separatedBy: "\n")
        for latLong in latLongString01 {
            var latLongDouble: [Double] = []
            let latLong_ = latLong.components(separatedBy: "/")
            for each in latLong_ {
                latLongDouble.append(Double(each)!)
            }
            returnArray.append(latLongDouble)
        }}
    print(returnArray)
    return returnArray
}


extension String {
    public func removeSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).filter { $0 != Character(" ")}
    }}


//newOne(str: coordString)


//getCoordsFromTextView(coordString)























