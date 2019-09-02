// To parse the JSON, add this file to your project and do:
//
//   let airfields = try? JSONDecoder().decode(Airfields.self, from: jsonData)

import Foundation

typealias Airfields = [Airfield]
//typealias Communications = [Communication]
//typealias CommFreqs = [CommFreq]
//typealias Navaids = [Navaid]
//typealias Runways = [Runway]

struct Airfield: Codable {
    let id: Int
    let icao: String
    let faa: String
    let country: String
    let name: String
    let state: String
    let elevation: Double
    let lat: Double
    let lon: Double
    let mgrs: String
    let timeConversion: String
    let communications: [Communication]
    let navaids: [Navaid]
    let runways: [Runway]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case icao = "ICAO"
        case faa = "FAA"
        case country = "Country"
        case name = "Name"
        case state = "State"
        case elevation = "Elevation"
        case lat = "Lat"
        case lon = "Lon"
        case mgrs = "MGRS"
        case timeConversion = "Time_Conversion"
        case communications = "Communications"
        case navaids = "Navaids"
        case runways = "Runways"
    }
}

struct Communication: Codable {
    let id: Int
    let name: String
    let freqs: [Freq]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "Name"
        case freqs = "Freqs"
    }
}

struct Freq: Codable {
    let id: Int
    let freq: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case freq = "Freq"
    }
}

struct Navaid: Codable {
    let id: Int
    let name: String
    let ident: String
    let type: String
    let lat: Double
    let lon: Double
    let frequency: Double
    let channel: Int
    let tacanDMEMode: String
    let course: Int
    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "Name"
        case ident = "Ident"
        case type = "Type"
        case lat = "Lat"
        case lon = "Lon"
        case frequency = "Frequency"
        case channel = "Channel"
        case tacanDMEMode = "Tacan_DME_Mode"
        case course = "Course"
        case distance = "Distance"
    }
}

struct Runway: Codable {
    let id: Int
    let lowID: String
    let highID: String
    let length: Double
    let width: Double
    let surfaceType: String //SurfaceType
    let runwayCondition: String //SurfaceType
    let magHdgHi: Double
    let magHdgLow: Double
    let trueHdgHi: Double
    let trueHdgLow: Double
    let coordLatHi: Double
    let coordLatLo: Double
    let coordLonHi: Double
    let coordLonLo: Double
    let elevHi: Double
    let elevLow: Double
    let slopeHi: Double
    let slopeLow: Double
    let tdzeHi: Double
    let tdzeLow: Double
    let overrunHiLength: Double
    let overrunLowLength: Double
    let overrunHiType: String //SurfaceType
    let overrunLowType: String //SurfaceType
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lowID = "lowID"
        case highID = "highID"
        case length = "Length"
        case width = "Width"
        case surfaceType = "SurfaceType"
        case runwayCondition = "RunwayCondition"
        case magHdgHi = "MagHdgHi"
        case magHdgLow = "MagHdgLow"
        case trueHdgHi = "TrueHdgHi"
        case trueHdgLow = "TrueHdgLow"
        case coordLatHi = "Coord_Lat_Hi"
        case coordLatLo = "Coord_Lat_Lo"
        case coordLonHi = "Coord_Lon_Hi"
        case coordLonLo = "Coord_Lon_Lo"
        case elevHi = "Elev_Hi"
        case elevLow = "Elev_Low"
        case slopeHi = "Slope_Hi"
        case slopeLow = "Slope_Low"
        case tdzeHi = "TDZE_Hi"
        case tdzeLow = "TDZE_Low"
        case overrunHiLength = "Overrun_Hi_Length"
        case overrunLowLength = "Overrun_Low_Length"
        case overrunHiType = "Overrun_Hi_Type"
        case overrunLowType = "Overrun_Low_Type"
    }
}

enum StateCode: String {
    //    case AL = "ALABAMA"
    //    case AK = "ALASKA"
    //    case AZ = "ARIZONA "
    //    case AR = "ARKANSAS"
    //    case CA = "CALIFORNIA "
    //    case CO = "COLORADO "
    //    case CT = "CONNECTICUT"
    //    case DE = "DELAWARE"
    //    case FL = "FLORIDA"
    //    case GA = "GEORGIA"
    //    case HI = "HAWAII"
    //    case ID = "IDAHO"
    //    case IL = "ILLINOIS"
    //    case IN = "INDIANA"
    //    case IA = "IOWA"
    //    case KS = "KANSAS"
    //    case KY = "KENTUCKY"
    //    case LA = "LOUISIANA"
    //    case ME = "MAINE"
    //    case MD = "MARYLAND"
    //    case MA = "MASSACHUSETTS"
    //    case MI = "MICHIGAN"
    //    case MN = "MINNESOTA"
    //    case MS = "MISSISSIPPI"
    //    case MO = "MISSOURI"
    //    case MT = "MONTANA"
    //    case NE = "NEBRASKA"
    //    case NV = "NEVADA"
    //    case NH = "NEW HAMPSHIRE"
    //    case NJ = "NEW JERSEY"
    //    case NM = "NEW MEXICO"
    //    case NY = "NEW YORK"
    //    case NC = "NORTH CAROLINA"
    //    case ND = "NORTH DAKOTA"
    //    case OH = "OHIO"
    //    case OK = "OKLAHOMA"
    //    case OR = "OREGON"
    //    case PA = "PENNSYLVANIA"
    //    case RI = "RHODE ISLAND"
    //    case SC = "SOUTH CAROLINA"
    //    case SD = "SOUTH DAKOTA"
    //    case TN = "TENNESSEE"
    //    case TX = "TEXAS"
    //    case UT = "UTAH"
    //    case VT = "VERMONT"
    //    case VA = "VIRGINIA "
    //    case WA = "WASHINGTON"
    //    case WV = "WEST VIRGINIA"
    //    case WI = "WISCONSIN"
    //    case WY = "WYOMING"
    case ALABAMA = "AL"
    case ALASKA = "AK"
    case ARIZONA  = "AZ"
    case ARKANSAS = "AR"
    case CALIFORNIA = "CA"
    case COLORADO = "CO"
    case CONNECTICUT = "CT"
    case DELAWARE = "DE"
    case FLORIDA = "FL"
    case GEORGIA = "GA"
    case HAWAII = "HI"
    case IDAHO = "ID"
    case ILLINOIS = "IL"
    case INDIANA = "IN"
    case IOWA = "IA"
    case KANSAS = "KS"
    case KENTUCKY = "KY"
    case LOUISIANA = "LA"
    case MAINE = "ME"
    case MARYLAND = "MD"
    case MASSACHUSETTS = "MA"
    case MICHIGAN = "MI"
    case MINNESOTA = "MN"
    case MISSISSIPPI = "MS"
    case MISSOURI = "MO"
    case MONTANA = "MT"
    case NEBRASKA = "NE"
    case NEVADA = "NV"
    case NEW_HAMPSHIRE = "NH"
    case NEW_JERSEY = "NJ"
    case NEW_MEXICO = "NM"
    case NEW_YORK = "NY"
    case NORTH_CAROLINA = "NC"
    case NORTH_DAKOTA = "ND"
    case OHIO = "OH"
    case OKLAHOMA = "OK"
    case OREGON = "OR"
    case PENNSYLVANIA = "PA"
    case RHODE_ISLAND = "RI"
    case SOUTH_CAROLINA = "SC"
    case SOUTH_DAKOTA = "SD"
    case TENNESSEE = "TN"
    case TEXAS = "TX"
    case UTAH = "UT"
    case VERMONT = "VT"
    case VIRGINIA = "VA"
    case WASHINGTON = "WA"
    case WEST_VIRGINIA = "WV"
    case WISCONSIN = "WI"
    case WYOMING = "WY"
    
    static let allValues = [
        ALABAMA,
        ALASKA,
        ARIZONA,
        ARKANSAS,
        CALIFORNIA,
        COLORADO,
        CONNECTICUT,
        DELAWARE,
        FLORIDA,
        GEORGIA,
        HAWAII,
        IDAHO,
        ILLINOIS,
        INDIANA,
        IOWA,
        KANSAS,
        KENTUCKY,
        LOUISIANA,
        MAINE,
        MARYLAND,
        MASSACHUSETTS,
        MICHIGAN,
        MINNESOTA,
        MISSISSIPPI,
        MISSOURI,
        MONTANA,
        NEBRASKA,
        NEVADA,
        NEW_HAMPSHIRE,
        NEW_JERSEY,
        NEW_MEXICO,
        NEW_YORK,
        NORTH_CAROLINA,
        NORTH_DAKOTA,
        OHIO,
        OKLAHOMA,
        OREGON,
        PENNSYLVANIA,
        RHODE_ISLAND,
        SOUTH_CAROLINA,
        SOUTH_DAKOTA,
        TENNESSEE,
        TEXAS,
        UTAH,
        VERMONT,
        VIRGINIA,
        WASHINGTON,
        WEST_VIRGINIA,
        WISCONSIN,
        WYOMING
    ]
}






