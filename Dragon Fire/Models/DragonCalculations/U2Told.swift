//
//  U2Told.swift
//  DragonCalculations
//
//  Created by Matthew Elmore on 8/3/18.
//  Copyright © 2018 Matthew Elmore. All rights reserved.
//

import Foundation


public struct U2Told {
    private var fuelLoad: FuelLoad
    private var ktJet: Double
    
    private var runwayCondition: RunwayCondition
    private var tempInF: Double
    private var fieldElev: Double
    private var windSpeed: Double
    private var windDirection: Double
    private var runwayHeading: Double
    
    private var flaps15: Bool
    private var SpoilersDeployed: Bool
    private var startTaxiTakeOff = 60.0
    
    
    public init(fuelLoad: FuelLoad,
                ktJet: Double,
                runwayCondition: RunwayCondition,
                tempInF: Double,
                fieldElev: Double,
                windSpeed: Double,
                windDirection: Double,
                runwayHeading: Double,
                flaps15: Bool,
                SpoilersDeployed: Bool) {
        self.fuelLoad = fuelLoad
        self.ktJet = ktJet
        self.runwayCondition = runwayCondition
        self.tempInF = tempInF
        self.fieldElev = fieldElev
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.runwayHeading = runwayHeading
        self.flaps15 = flaps15
        self.SpoilersDeployed = SpoilersDeployed
    }
    
    public func windComponents() -> (headWind: Double, tailWind: Double, crossWind: Double) {
        var headWind = 0.0
        var tailWind = 0.0
        let crossWind = self.windSpeed*abs(sin(abs((self.runwayHeading-self.windDirection).degreesToRadians)))
        let headTailWind = self.windSpeed*cos(abs((self.runwayHeading-self.windDirection).degreesToRadians))
        if headTailWind < 0 {
            headWind = 0.0
            tailWind = headTailWind
        } else if headTailWind > 0 {
            headWind = headTailWind
            tailWind = 0.0
        }
        return (headWind: headWind, tailWind: tailWind, crossWind: crossWind)
    }
    
    public func takeOffWeight() -> Double {
        let zfw = 18700.0
        let gasWeight = 6.5 //per gallon
        let jet = (self.ktJet * 650.0) + zfw
        let fuelWeight = gasWeight * (self.fuelLoad.rawValue - startTaxiTakeOff)
        let totalWeight = jet + fuelWeight
        return totalWeight
    }
    
    
    // MARK: - Formulas are best trend line from excel
    public func airspeeds() -> (bestGlide: Double, minSink: Double, flapsUp: Double, flaps35: Double) {
        let fuelUsedForCalculations = self.fuelLoad.rawValue - self.startTaxiTakeOff
        //Best Glide
        let bestGlide = (0.0101 * fuelUsedForCalculations) + 104.65 + self.ktJet
        //Min Sink
        let minSink = (0.0101 * fuelUsedForCalculations) + 89.649 + self.ktJet
        //0° Flaps
        let flapsUp = (0.0101 * fuelUsedForCalculations) + 74.649 + self.ktJet
        //35° Flaps
        let flaps35 = (0.0101 * fuelUsedForCalculations) + 69.649 + self.ktJet
        return (bestGlide: bestGlide, minSink: minSink, flapsUp: flapsUp, flaps35: flaps35)
    }
    
    private func takeOffTempCorrectionFor(numberToApplyCorrection: Double) -> Double {
        let tempCorrectionPerDegree = 0.0026
        let tempAbove59: Double = {
            if self.tempInF < 59 {
                return 0.0
            } else {
                return self.tempInF - 59.0
            }
        }()
        return (numberToApplyCorrection) * (tempAbove59 * tempCorrectionPerDegree)
    }
    private func takeOffAltCorrectionFor(numberToApplyCorrection: Double) -> Double {
        return (numberToApplyCorrection * self.fieldElev * 0.000073) //corrected for each foot
    }
    
    private func takeOffTailWindCorrectionFor(numberToApplyCorrection: Double) -> Double {
        return (numberToApplyCorrection * 0.028 * windComponents().tailWind)
    }
    private func takeOffHeadWindCorrectionFor(numberToApplyCorrection: Double) -> Double {
        return -1 * (numberToApplyCorrection * 0.017 * windComponents().headWind)
    }
    private func takeOffFlaps15Correction(numberToApplyCorrection: Double) -> Double {
        var result = 0.0
        if self.flaps15 == true {
            result = -1 * (numberToApplyCorrection * 0.19)
        } else {
            result = 0.0
        }
        return result
    }

    public func takeOffGroundDistanceChartP3() -> (takeOffSpeed: Double, takeOffDistance: Double) {
        let grossWeight = takeOffWeight()
        //Pg P-3
//        let takeOffSpeed = 0.4711 * grossWeight^0.5149 // pow(grossWeight, 0.5149)
        let takeOffSpeed = 0.4711 * (pow(grossWeight, 0.5149))
        let distanceCoefficient = [0.080685621, -1.4223744, 9.9947730, -34.280990, 52.23782, 0.0000000, 27.724617, 0.0000000, 56.041388]
        let weight = grossWeight/10000
//        let takeOffDistance = (distanceCoefficient[0] * weight^8) + (distanceCoefficient[1] * weight^7) + (distanceCoefficient[2] * weight^6) + (distanceCoefficient[3] * weight^5) + (distanceCoefficient[4] * weight^4) + (distanceCoefficient[5] * weight^3) + (distanceCoefficient[6] * weight^2) + (distanceCoefficient[7] * weight^1) + (distanceCoefficient[8] * weight^0)
        let takeOffDistance = (distanceCoefficient[0] * pow(weight, 8)) + (distanceCoefficient[1] * pow(weight, 7)) + (distanceCoefficient[2] * pow(weight, 6)) + (distanceCoefficient[3] * pow(weight, 5)) + (distanceCoefficient[4] * pow(weight, 4)) + (distanceCoefficient[5] * pow(weight, 3)) + (distanceCoefficient[6] * pow(weight, 2)) + (distanceCoefficient[7] * pow(weight, 1)) + (distanceCoefficient[8] * pow(weight, 0))
        
        //Take off speed calculations
        let takeOffSpeedWithTempCorrection = takeOffTempCorrectionFor(numberToApplyCorrection: takeOffSpeed)
        let takeOffSpeedCorrectedForFieldElev = takeOffAltCorrectionFor(numberToApplyCorrection: takeOffSpeed)
        let takeOffSpeedCorrectedForTailWind = takeOffTailWindCorrectionFor(numberToApplyCorrection: takeOffSpeed)
        let takeOffSpeedCorrectedForHeadWind = takeOffHeadWindCorrectionFor(numberToApplyCorrection: takeOffSpeed)
        let takeOffSpeedCorrectedForFlaps15 = takeOffFlaps15Correction(numberToApplyCorrection: takeOffSpeed)
        let takeOffSpeedFinal = takeOffSpeed + takeOffSpeedWithTempCorrection + takeOffSpeedCorrectedForFieldElev + takeOffSpeedCorrectedForTailWind + takeOffSpeedCorrectedForHeadWind + takeOffSpeedCorrectedForFlaps15
        
        //Take off distance calculations
        let takeOffDistWithTempCorrection = takeOffTempCorrectionFor(numberToApplyCorrection: takeOffDistance)
        let takeOffDistCorrectedForFieldElev = takeOffAltCorrectionFor(numberToApplyCorrection: takeOffDistance)
        let takeOffDistCorrectedForTailWind = takeOffTailWindCorrectionFor(numberToApplyCorrection: takeOffDistance)
        let takeOffDistCorrectedForHeadWind = takeOffHeadWindCorrectionFor(numberToApplyCorrection: takeOffDistance)
        let takeOffDistCorrectedForFlaps15 = takeOffFlaps15Correction(numberToApplyCorrection: takeOffDistance)
        let takeOffDistanceFinal = takeOffDistance + takeOffDistWithTempCorrection + takeOffDistCorrectedForFieldElev + takeOffDistCorrectedForTailWind + takeOffDistCorrectedForHeadWind + takeOffDistCorrectedForFlaps15
        return (takeOffSpeed: takeOffSpeedFinal, takeOffDistance: takeOffDistanceFinal)
    }
   
    private func abortStopTempCorrection(numberToApplyCorrection: Double) -> Double {
        let tempCorrectionPerDegree = 0.003
        let tempFrom59: Double = self.tempInF - 59.0
        return (numberToApplyCorrection) * (tempFrom59 * tempCorrectionPerDegree)
    }
    private func abortStopAltCorrection(numberToApplyCorrection: Double) -> Double {
        //I'm Assuming a typo and its Sealevel not Field Elevation
        return (numberToApplyCorrection * self.fieldElev * 0.000053) //corrected for each foot
    }
    private func abortStopTailWindCorrection(numberToApplyCorrection: Double) -> Double {
        return (numberToApplyCorrection * 0.025 * windComponents().tailWind)
    }
    private func abortStopHeadWindCorrection(numberToApplyCorrection: Double) -> Double {
        return -1 * (numberToApplyCorrection * 0.015 * windComponents().headWind)
    }
    private func abortStopFlaps15Correction(numberToApplyCorrection: Double) -> Double {
        var result = 0.0
        if self.flaps15 == true {
            result =  -1 * (numberToApplyCorrection * 0.30)
        } else {
            result = 0.0
        }
        return result
    }
    private func abortStopSpoilersDeployedCorrection(numberToApplyCorrection: Double) -> Double {
        var result = 0.0
        if self.SpoilersDeployed == false {
            result = (numberToApplyCorrection * 0.27)
        } else {
            result = 0.0
        }
        return result
    }
    
    
    public func abortStoppingDistancePW() -> Double {
        let weight = takeOffWeight()
        let condition = self.runwayCondition
        
        var result = 0.0
        switch condition{
        case .dry:
            let resultDistance: [Double] = [3673, 3850, 4027, 4203, 4380, 4556, 4732, 4908, 5084, 5259, 5498, 5930, 6355, 6775, 7188, 7595, 7998, 8396, 8790, 9180, 9567]
            let slope: [Double] = [0.177, 0.177, 0.176, 0.177, 0.176, 0.176, 0.176, 0.176, 0.175, 0.239, 0.432, 0.425, 0.420, 0.413, 0.407, 0.403, 0.398, 0.394, 0.390, 0.387]
            let yIntercept: [Double] = [133, 133, 155, 132, 156, 156, 156, 156, 184, -1672, -7462, -7245, -7085, -6854, -6650, -6510, -6330, -6182, -6030, -5913]
            if weight == 20000 {
                result = resultDistance[0]
            } else if weight > 20000 && weight < 21000 {
                result = weight * slope[0] + yIntercept[0]
            } else if weight == 21000 {
                result = resultDistance[1]
            } else if weight > 21000 && weight < 22000 {
                result = weight * slope[1] + yIntercept[1]
            } else if weight == 22000 {
                result = resultDistance[2]
            } else if weight > 22000 && weight < 23000 {
                result = weight * slope[2] + yIntercept[2]
            } else if weight == 23000 {
                result = resultDistance[3]
            } else if weight > 23000 && weight < 24000 {
                result = weight * slope[3] + yIntercept[3]
            } else if weight == 24000 {
                result = resultDistance[4]
            } else if weight > 24000 && weight < 25000 {
                result = weight * slope[4] + yIntercept[4]
            } else if weight == 25000 {
                result = resultDistance[5]
            } else if weight > 25000 && weight < 26000 {
                result = weight * slope[5] + yIntercept[5]
            } else if weight == 26000 {
                result = resultDistance[6]
            } else if weight > 26000 && weight < 27000 {
                result = weight * slope[6] + yIntercept[6]
            } else if weight == 27000 {
                result = resultDistance[7]
            } else if weight > 27000 && weight < 28000 {
                result = weight * slope[7] + yIntercept[7]
            } else if weight == 28000 {
                result = resultDistance[8]
            } else if weight > 28000 && weight < 29000 {
                result = weight * slope[8] + yIntercept[8]
            } else if weight == 29000 {
                result = resultDistance[9]
            } else if weight > 29000 && weight < 30000 {
                result = weight * slope[9] + yIntercept[9]
            } else if weight == 30000 {
                result = resultDistance[10]
            } else if weight > 30000 && weight < 31000 {
                result = weight * slope[10] + yIntercept[10]
            } else if weight == 31000 {
                result = resultDistance[11]
            } else if weight > 31000 && weight < 32000 {
                result = weight * slope[11] + yIntercept[11]
            } else if weight == 32000 {
                result = resultDistance[12]
            } else if weight > 32000 && weight < 33000 {
                result = weight * slope[12] + yIntercept[12]
            } else if weight == 33000 {
                result = resultDistance[13]
            } else if weight > 33000 && weight < 34000 {
                result = weight * slope[13] + yIntercept[13]
            } else if weight == 34000 {
                result = resultDistance[14]
            } else if weight > 34000 && weight < 35000 {
                result = weight * slope[14] + yIntercept[14]
            } else if weight == 35000 {
                result = resultDistance[15]
            } else if weight > 35000 && weight < 36000 {
                result = weight * slope[15] + yIntercept[15]
            } else if weight == 36000 {
                result = resultDistance[16]
            } else if weight > 36000 && weight < 37000 {
                result = weight * slope[16] + yIntercept[16]
            } else if weight == 37000 {
                result = resultDistance[17]
            } else if weight > 37000 && weight < 38000 {
                result = weight * slope[17] + yIntercept[17]
            } else if weight == 38000 {
                result = resultDistance[18]
            } else if weight > 38000 && weight < 39000 {
                result = weight * slope[18] + yIntercept[18]
            } else if weight == 39000 {
                result = resultDistance[19]
            } else if weight > 39000 && weight < 40000 {
                result = weight * slope[19] + yIntercept[19]
            } else if weight == 40000 {
                result = resultDistance[20]
            } else if weight > 40000 {
                result = 0.0
            }
        case .wet:
            let resultDistance: [Double] = [3932, 4122, 4312, 4502, 4692, 4881, 5070, 5269, 5448, 5637, 5825, 6179, 6593, 7001, 7405, 7803, 8198, 8588, 8975, 9358, 9738]
            let slope: [Double] = [0.190, 0.190, 0.190, 0.190, 0.189, 0.189, 0.199, 0.179, 0.189, 0.188, 0.354, 0.414, 0.408, 0.404, 0.398, 0.395, 0.390, 0.387, 0.383, 0.380]
            let yIntercept: [Double] = [132, 132, 132, 132, 156, 156, -104, 436, 156, 185, -4795, -6655, -6463, -6331, -6127, -6022, -5842, -5731, -5579, -5462]
            if weight == 20000 {
                result = resultDistance[0]
            } else if weight > 20000 && weight < 21000 {
                result = weight * slope[0] + yIntercept[0]
            } else if weight == 21000 {
                result = resultDistance[1]
            } else if weight > 21000 && weight < 22000 {
                result = weight * slope[1] + yIntercept[1]
            } else if weight == 22000 {
                result = resultDistance[2]
            } else if weight > 22000 && weight < 23000 {
                result = weight * slope[2] + yIntercept[2]
            } else if weight == 23000 {
                result = resultDistance[3]
            } else if weight > 23000 && weight < 24000 {
                result = weight * slope[3] + yIntercept[3]
            } else if weight == 24000 {
                result = resultDistance[4]
            } else if weight > 24000 && weight < 25000 {
                result = weight * slope[4] + yIntercept[4]
            } else if weight == 25000 {
                result = resultDistance[5]
            } else if weight > 25000 && weight < 26000 {
                result = weight * slope[5] + yIntercept[5]
            } else if weight == 26000 {
                result = resultDistance[6]
            } else if weight > 26000 && weight < 27000 {
                result = weight * slope[6] + yIntercept[6]
            } else if weight == 27000 {
                result = resultDistance[7]
            } else if weight > 27000 && weight < 28000 {
                result = weight * slope[7] + yIntercept[7]
            } else if weight == 28000 {
                result = resultDistance[8]
            } else if weight > 28000 && weight < 29000 {
                result = weight * slope[8] + yIntercept[8]
            } else if weight == 29000 {
                result = resultDistance[9]
            } else if weight > 29000 && weight < 30000 {
                result = weight * slope[9] + yIntercept[9]
            } else if weight == 30000 {
                result = resultDistance[10]
            } else if weight > 30000 && weight < 31000 {
                result = weight * slope[10] + yIntercept[10]
            } else if weight == 31000 {
                result = resultDistance[11]
            } else if weight > 31000 && weight < 32000 {
                result = weight * slope[11] + yIntercept[11]
            } else if weight == 32000 {
                result = resultDistance[12]
            } else if weight > 32000 && weight < 33000 {
                result = weight * slope[12] + yIntercept[12]
            } else if weight == 33000 {
                result = resultDistance[13]
            } else if weight > 33000 && weight < 34000 {
                result = weight * slope[13] + yIntercept[13]
            } else if weight == 34000 {
                result = resultDistance[14]
            } else if weight > 34000 && weight < 35000 {
                result = weight * slope[14] + yIntercept[14]
            } else if weight == 35000 {
                result = resultDistance[15]
            } else if weight > 35000 && weight < 36000 {
                result = weight * slope[15] + yIntercept[15]
            } else if weight == 36000 {
                result = resultDistance[16]
            } else if weight > 36000 && weight < 37000 {
                result = weight * slope[16] + yIntercept[16]
            } else if weight == 37000 {
                result = resultDistance[17]
            } else if weight > 37000 && weight < 38000 {
                result = weight * slope[17] + yIntercept[17]
            } else if weight == 38000 {
                result = resultDistance[18]
            } else if weight > 38000 && weight < 39000 {
                result = weight * slope[18] + yIntercept[18]
            } else if weight == 39000 {
                result = resultDistance[19]
            } else if weight > 39000 && weight < 40000 {
                result = weight * slope[19] + yIntercept[19]
            } else if weight == 40000 {
                result = resultDistance[20]
            } else if weight > 40000 {
                result = 0.0
            }
        case .snow:
            let resultDistance: [Double] = [4648,4875,5101,5327,5553,5779,6005,6230,6456,6681,6906,7131,7385,7759,8130,8499,8865,9230,9592,9952,10310]
            let slope: [Double] = [0.227, 0.226, 0.226, 0.226, 0.226, 0.226, 0.225, 0.226, 0.225, 0.225, 0.225, 0.254, 0.374, 0.371, 0.369, 0.366, 0.365, 0.362, 0.360, 0.358]
            let yIntercept: [Double] = [108, 129, 129, 129, 129, 129, 155, 128, 156, 156, 156, -743, -4583, -4484, -4416, -4311, -4275, -4164, -4088, -4010]
            if weight == 20000 {
                result = resultDistance[0]
            } else if weight > 20000 && weight < 21000 {
                result = weight * slope[0] + yIntercept[0]
            } else if weight == 21000 {
                result = resultDistance[1]
            } else if weight > 21000 && weight < 22000 {
                result = weight * slope[1] + yIntercept[1]
            } else if weight == 22000 {
                result = resultDistance[2]
            } else if weight > 22000 && weight < 23000 {
                result = weight * slope[2] + yIntercept[2]
            } else if weight == 23000 {
                result = resultDistance[3]
            } else if weight > 23000 && weight < 24000 {
                result = weight * slope[3] + yIntercept[3]
            } else if weight == 24000 {
                result = resultDistance[4]
            } else if weight > 24000 && weight < 25000 {
                result = weight * slope[4] + yIntercept[4]
            } else if weight == 25000 {
                result = resultDistance[5]
            } else if weight > 25000 && weight < 26000 {
                result = weight * slope[5] + yIntercept[5]
            } else if weight == 26000 {
                result = resultDistance[6]
            } else if weight > 26000 && weight < 27000 {
                result = weight * slope[6] + yIntercept[6]
            } else if weight == 27000 {
                result = resultDistance[7]
            } else if weight > 27000 && weight < 28000 {
                result = weight * slope[7] + yIntercept[7]
            } else if weight == 28000 {
                result = resultDistance[8]
            } else if weight > 28000 && weight < 29000 {
                result = weight * slope[8] + yIntercept[8]
            } else if weight == 29000 {
                result = resultDistance[9]
            } else if weight > 29000 && weight < 30000 {
                result = weight * slope[9] + yIntercept[9]
            } else if weight == 30000 {
                result = resultDistance[10]
            } else if weight > 30000 && weight < 31000 {
                result = weight * slope[10] + yIntercept[10]
            } else if weight == 31000 {
                result = resultDistance[11]
            } else if weight > 31000 && weight < 32000 {
                result = weight * slope[11] + yIntercept[11]
            } else if weight == 32000 {
                result = resultDistance[12]
            } else if weight > 32000 && weight < 33000 {
                result = weight * slope[12] + yIntercept[12]
            } else if weight == 33000 {
                result = resultDistance[13]
            } else if weight > 33000 && weight < 34000 {
                result = weight * slope[13] + yIntercept[13]
            } else if weight == 34000 {
                result = resultDistance[14]
            } else if weight > 34000 && weight < 35000 {
                result = weight * slope[14] + yIntercept[14]
            } else if weight == 35000 {
                result = resultDistance[15]
            } else if weight > 35000 && weight < 36000 {
                result = weight * slope[15] + yIntercept[15]
            } else if weight == 36000 {
                result = resultDistance[16]
            } else if weight > 36000 && weight < 37000 {
                result = weight * slope[16] + yIntercept[16]
            } else if weight == 37000 {
                result = resultDistance[17]
            } else if weight > 37000 && weight < 38000 {
                result = weight * slope[17] + yIntercept[17]
            } else if weight == 38000 {
                result = resultDistance[18]
            } else if weight > 38000 && weight < 39000 {
                result = weight * slope[18] + yIntercept[18]
            } else if weight == 39000 {
                result = resultDistance[19]
            } else if weight > 39000 && weight < 40000 {
                result = weight * slope[19] + yIntercept[19]
            } else if weight == 40000 {
                result = resultDistance[20]
            } else if weight > 40000 {
                result = 0.0
            }
        case .ice:
            let resultDistance: [Double] = [5823, 6110, 6397, 6684, 6971, 7257, 7544, 7830, 8116, 8402, 8688, 8973, 9259, 9544, 9830, 10122, 10426, 10732, 11039, 11348, 11657]
            let slope: [Double] = [0.287, 0.287, 0.287, 0.287, 0.286, 0.287, 0.286, 0.286, 0.286, 0.286, 0.285, 0.286, 0.285, 0.286, 0.292, 0.304, 0.306, 0.307, 0.309, 0.309]
            let yIntercept: [Double] = [83, 83, 83, 83, 107, 82, 108, 108, 108, 108, 138, 107, 139, 106, -98, -518, -590, -627, -703, -703]
            if weight == 20000 {
                result = resultDistance[0]
            } else if weight > 20000 && weight < 21000 {
                result = weight * slope[0] + yIntercept[0]
            } else if weight == 21000 {
                result = resultDistance[1]
            } else if weight > 21000 && weight < 22000 {
                result = weight * slope[1] + yIntercept[1]
            } else if weight == 22000 {
                result = resultDistance[2]
            } else if weight > 22000 && weight < 23000 {
                result = weight * slope[2] + yIntercept[2]
            } else if weight == 23000 {
                result = resultDistance[3]
            } else if weight > 23000 && weight < 24000 {
                result = weight * slope[3] + yIntercept[3]
            } else if weight == 24000 {
                result = resultDistance[4]
            } else if weight > 24000 && weight < 25000 {
                result = weight * slope[4] + yIntercept[4]
            } else if weight == 25000 {
                result = resultDistance[5]
            } else if weight > 25000 && weight < 26000 {
                result = weight * slope[5] + yIntercept[5]
            } else if weight == 26000 {
                result = resultDistance[6]
            } else if weight > 26000 && weight < 27000 {
                result = weight * slope[6] + yIntercept[6]
            } else if weight == 27000 {
                result = resultDistance[7]
            } else if weight > 27000 && weight < 28000 {
                result = weight * slope[7] + yIntercept[7]
            } else if weight == 28000 {
                result = resultDistance[8]
            } else if weight > 28000 && weight < 29000 {
                result = weight * slope[8] + yIntercept[8]
            } else if weight == 29000 {
                result = resultDistance[9]
            } else if weight > 29000 && weight < 30000 {
                result = weight * slope[9] + yIntercept[9]
            } else if weight == 30000 {
                result = resultDistance[10]
            } else if weight > 30000 && weight < 31000 {
                result = weight * slope[10] + yIntercept[10]
            } else if weight == 31000 {
                result = resultDistance[11]
            } else if weight > 31000 && weight < 32000 {
                result = weight * slope[11] + yIntercept[11]
            } else if weight == 32000 {
                result = resultDistance[12]
            } else if weight > 32000 && weight < 33000 {
                result = weight * slope[12] + yIntercept[12]
            } else if weight == 33000 {
                result = resultDistance[13]
            } else if weight > 33000 && weight < 34000 {
                result = weight * slope[13] + yIntercept[13]
            } else if weight == 34000 {
                result = resultDistance[14]
            } else if weight > 34000 && weight < 35000 {
                result = weight * slope[14] + yIntercept[14]
            } else if weight == 35000 {
                result = resultDistance[15]
            } else if weight > 35000 && weight < 36000 {
                result = weight * slope[15] + yIntercept[15]
            } else if weight == 36000 {
                result = resultDistance[16]
            } else if weight > 36000 && weight < 37000 {
                result = weight * slope[16] + yIntercept[16]
            } else if weight == 37000 {
                result = resultDistance[17]
            } else if weight > 37000 && weight < 38000 {
                result = weight * slope[17] + yIntercept[17]
            } else if weight == 38000 {
                result = resultDistance[18]
            } else if weight > 38000 && weight < 39000 {
                result = weight * slope[18] + yIntercept[18]
            } else if weight == 39000 {
                result = resultDistance[19]
            } else if weight > 39000 && weight < 40000 {
                result = weight * slope[19] + yIntercept[19]
            } else if weight == 40000 {
                result = resultDistance[20]
            } else if weight > 40000 {
                result = 0.0
            }
        }
        let distCorrectedForTemp = abortStopTempCorrection(numberToApplyCorrection: result)
        let distCorrectedForAlt = abortStopAltCorrection(numberToApplyCorrection: result)
        let distCorrectedForTailWind = abortStopTailWindCorrection(numberToApplyCorrection: result)
        let distCorrectedForHeadWind = abortStopHeadWindCorrection(numberToApplyCorrection: result)
        let distCorrectedForSpoilers = abortStopSpoilersDeployedCorrection(numberToApplyCorrection: result)
        let distCorrectedForFlaps15 = abortStopFlaps15Correction(numberToApplyCorrection: result)
        let finalResult = result + distCorrectedForTemp + distCorrectedForAlt + distCorrectedForTailWind + distCorrectedForHeadWind + distCorrectedForSpoilers + distCorrectedForFlaps15
        return finalResult
    }
}











