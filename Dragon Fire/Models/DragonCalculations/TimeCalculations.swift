//
//  TimeCalculations.swift
//  DragonCalculations
//
//  Created by Matthew Elmore on 10/11/18.
//  Copyright © 2018 Matthew Elmore. All rights reserved.
//

import Foundation

struct TimeCalculations {
    private let latitude: Double
    private let longitude: Double
    private let timeZ = TimeZone.current
    private var timeZone: Double
    private var date: Date
    
    init(latitude: Double,
         longitude: Double,
         date: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.timeZone = Double(timeZ.secondsFromGMT(for: date) / (3600))
    }
    
    private func jdFromDate() -> Double {
        let julianDate = self.date.timeIntervalSince1970 / (60 * 60 * 24) + 25569.0
        let calender = Calendar.current
        let localHour = Double(calender.component(.hour, from: date))
        let localMinute = Double(calender.component(.minute, from: date))
        let localSecond = Double(calender.component(.second, from: date))
        let timeProprtionToDay = (localHour + (localMinute/60) + (localSecond/3600))/24
        let julianDay = julianDate + 2415018.5 + timeProprtionToDay - (self.timeZone/24)
        return julianDay
    }
    private func julianCentury() -> Double {
        let jd = jdFromDate()
        return (jd-2451545)/36525
    }
    private func geomMeanLongSun() -> Double {
        let innerFunc = (36000.76983 + julianCentury() * 0.0003032)
        let outerFunc = (280.46646 + julianCentury() * innerFunc)
        return outerFunc.truncatingRemainder(dividingBy: 360)
    }
    
    private func geomMeanAnomSunDegrees() -> Double {
        return 357.52911 + julianCentury() * (35999.05029 - 0.0001537 * julianCentury())
    }
    
    private func eccentEarthOrbit() -> Double{
        return 0.016708634 - julianCentury() * (0.000042037 + 0.0000001267 * julianCentury())
    }
    private func sunEqOfCtr() -> Double {
        let J2 = geomMeanAnomSunDegrees()
        let G2 = julianCentury()
        let a = sin(J2.toRadians())
        let b = 1.914602 - G2 * (0.004817 + 0.000014 * G2)
        let c = sin((J2 * 2).toRadians())
        let d = 0.019993 - 0.000101 * G2
        let e = sin((J2 * 3).toRadians())
        return a * b + c * d + e * 0.000289
    }
    
    private func sunTrueLongDegrees() -> Double {
        return geomMeanLongSun() + sunEqOfCtr()
    }
    
    private func sunTrueAnomDegrees() -> Double {
        return geomMeanAnomSunDegrees() + sunEqOfCtr()
    }
    
    private func sunRadVectorAUs() -> Double {
        let K2 = eccentEarthOrbit()
        let N2 = sunTrueAnomDegrees()
        let a = 1.000001018 * (1 - K2 * K2)
        let b = 1 + K2 * cos(N2.toRadians())
        return a/b
    }
    
    private func sunAppLong() -> Double {
        let M2 = sunTrueLongDegrees()
        let G2 = julianCentury()
        let a = (125.04 - 1934.136 * G2).toRadians()
        return M2 - 0.00569 - 0.00478 * sin(a)
    }
    
    private func meanObliqEclipticDegrees() -> Double {
        let G2 = julianCentury()
        return 23 + (26 + ((21.448 - G2 * (46.815 + G2 * (0.00059 - G2 * 0.001813))))/60)/60
    }
    
    private func obliqCorrDegrees() -> Double {
        let Q2 = meanObliqEclipticDegrees()
        let G2 = julianCentury()
        let a = cos((125.04 - 1934.136 * G2).toRadians())
        return Q2 + 0.00256 * a
    }
    
    private func sunRtAscenDegrees() -> Double {
        let R2 = obliqCorrDegrees()
        let P2 = sunAppLong()
        let a = cos(P2.toRadians())
        let b = cos(R2.toRadians()) * sin(P2.toRadians())
        return atan2(b, a).toDegrees()
    }
    
    private func sunDeclinationsDegrees() -> Double {
        let R2 = obliqCorrDegrees()
        let P2 = sunAppLong()
        let a = sin(R2.toRadians())
        let b = sin(P2.toRadians())
        return asin(a * b).toDegrees()
    }
    
    private func varY() -> Double {
        let R2 = obliqCorrDegrees()
        let a = tan((R2/2).toRadians())
        return a * a
    }
    
    private func eqOfTimeMinutes() -> Double {
        let U2 = varY()
        let I2 = geomMeanLongSun()
        let K2 = eccentEarthOrbit()
        let J2 = geomMeanAnomSunDegrees()
        let a = U2 * sin(2 * I2.toRadians())
        let b = 2 * K2 * sin(J2.toRadians())
        let c = 4 * K2 * U2 * sin(J2.toRadians()) * cos(2 * I2.toRadians())
        let d = 0.5 * U2 * U2 * sin(4 * I2.toRadians())
        let f = 1.25 * K2 * K2 * sin(2 * J2.toRadians())
        return 4 * (a - b + c - d - f).toDegrees()
    }
    
    private func haSunriseDegrees() -> Double {
        let B2 = latitude
        let T2 = sunDeclinationsDegrees()
        let a = cos(90.833.toRadians())
        let b = cos(B2.toRadians())
        let c = cos(T2.toRadians())
        let e = 1 * tan(B2.toRadians()) * tan(T2.toRadians())
        return acos(a/(b*c) - e).toDegrees()
    }
    
    private func solorNoonLST() -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let B3 = longitude
        let B4 = timeZone
        let V2 = eqOfTimeMinutes()
        let dayPropartion = (720 - 4 * B3 - V2 + B4 * 60) / 1440
        return dayPropartion
    }
    
    private func sunriseTime() -> Double {
        let X2 = solorNoonLST()
        let W2 = haSunriseDegrees()
        return (X2 * 1440 - W2 * 4) / 1440
    }
    
    private func sunsetTime() -> Double {
        let X2 = solorNoonLST()
        let W2 = haSunriseDegrees()
        return (X2 * 1440 + W2 * 4) / 1440
    }
    
    private func sunlightDuration() -> (minutes: Double, hhmmss: String) {
        let W2 = haSunriseDegrees()
        let totalMinutes = 8 * W2
        let hours = Int(floor(totalMinutes/60))
        let minutes = Int(floor(totalMinutes - (Double(hours * 60))))
        let hhmmss = "\(hours)hr : \(minutes)min"
        return (minutes: totalMinutes, hhmmss: hhmmss)
    }
    
    private func convertDecDayIntoTime(decTime: Double) -> String {
        let numberOfSeconds = decTime * 86400
        let hour = Int(floor(numberOfSeconds / 3600))
        let minute = Int(floor((numberOfSeconds - (Double(hour) * 3600)) / 60))
        let timeString = "\(hour):\(minute)"
        return timeString
    }
    
    public func sunTimes() -> (sunrise: String, sunset: String, durationMinutes: Double, durationFormatted: String) {
        let sunrise = convertDecDayIntoTime(decTime: sunriseTime())
        let sunset = convertDecDayIntoTime(decTime: sunsetTime())
        let duration = sunlightDuration().minutes
        let durationFormatted = sunlightDuration().hhmmss
        return (sunrise: sunrise, sunset: sunset, durationMinutes: duration, durationFormatted: durationFormatted)
    }
    
    public func julianDay() -> Int {
        let currentDate = Date()
        let calender = Calendar.current
        let currentYear = calender.component(.year, from: currentDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let someDateTime = formatter.date(from: "\(currentYear)/1/1 00:01:00")
        let numberOfDays = Int(floor(currentDate.timeIntervalSince(someDateTime!) / (60 * 60 * 24)) + 1)
        return numberOfDays
    }
    
    public func times() -> (zuluDate: String, zuluTime: String, localDate: String, localTime: String) {
        let today = Date()
        let zuluTimeZone = TimeZone(identifier: "UTC")
        let zuluDateFormat = DateFormatter()
        let zuluTimeFormat = DateFormatter()
        zuluDateFormat.dateStyle = .medium
        zuluDateFormat.timeZone = zuluTimeZone
        zuluTimeFormat.timeStyle = .medium
        zuluTimeFormat.timeZone = zuluTimeZone
        let localDateFormat = DateFormatter()
        let localTimeFormat = DateFormatter()
        localDateFormat.dateStyle = .medium
        localTimeFormat.timeStyle = .medium
        let zuluDate = zuluDateFormat.string(from: today)
        let zuluTime = zuluTimeFormat.string(from: today)
        let localDate = localDateFormat.string(from: today)
        let localTime = localTimeFormat.string(from: today)
        return (zuluDate: zuluDate, zuluTime: zuluTime, localDate: localDate, localTime: localTime)
    }
    
}
