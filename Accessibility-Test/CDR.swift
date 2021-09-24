//
//  CDR.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 4/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import UIKit
import CoreLocation

func cdrType(from: String) -> CdrType {
    switch from {
    case "public":
        return .Public
    case "home":
        return .Home
    case "depot":
        return .Depot
    default:
        return .Public
    }
}

func cdrIcon(from: CdrType) -> UIImage {
    switch from {
    case .Public:
        return UIImage(named: "icon_onthego") ?? UIImage()
    case .Home:
        return UIImage(named: "icon_home") ?? UIImage()
    case .Depot:
        return UIImage(named: "icon_office") ?? UIImage()
    }
}

func cdrText(from: CdrType) -> String {
    switch from {
    case .Public:
        return "On the go"
    case .Home:
        return "Home"
    case .Depot:
        return "Office"
    }
}

enum CdrType: String {
    case Public = "public"
    case Home = "home"
    case Depot = "depot"
}

struct CdrList: Decodable {
    let cdrs: [Cdr]
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case cdrs = "cdrs"
        case count = "count"
    }
}

struct Cdr: Decodable {
    let uid: String?
    let idCpo: String?
    let evseId: String?
    let authMode: String?
    let sessionStart: String?
    let sessionEnd: String?
    let street: String?
    let postalCode: String?
    let city: String?
    let country: String?
    let consumedEnergy: Double?
    let consumedTime: Double?
    let odometerValue: Int?
    let cdrTypeRaw: String?
    let latitude: Double?
    let longitude: Double?
    let operatorName: String?
    
    func type() -> CdrType? {
        guard let cdrTypeRaw = cdrTypeRaw else {
            return nil
        }
        
        return cdrType(from: cdrTypeRaw)
    }
    
    func coordinates() -> CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func address() -> String? {
        guard street != nil || postalCode != nil || city != nil || country != nil else {
            return nil
        }

        let country = LocaleHelper.countryName(forKey: self.country ?? "")
        var address: String
        
        if let postalCode = self.postalCode {
            address = "\(self.street ?? "-")\n\(postalCode) \(self.city ?? "-"), \(country)"
        } else {
            address = "\(self.street ?? "-")\n\(self.city ?? "-"), \(country)"
        }
        
        return address
    }
    
    func formattedPower() -> String? {
        guard let energy = consumedEnergy else {
            return nil
        }
        
        return ConsumptionHelper.format(energy)
    }
    
    func formattedTime(_ format: Duration.DurationFormat = .short) -> String? {
        guard let time = consumedTime else {
            return nil
        }
        
        return Duration.from(seconds: Int(time), format: format)
    }
    
    func formattedOdometer() -> String? {
        guard let odometerValue = odometerValue else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        if let format = formatter.string(from: NSNumber(value: odometerValue)) {
            return "\(format) km"
        }
        
        return nil
    }
    
    func formattedSessionStart() -> String? {
        guard let sessionStart = sessionStart else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        guard let date = parser.date(from: sessionStart) else {
            return nil
        }
        
        return formatter.string(from: date)
    }
    
    func formattedSessionEnd() -> String? {
        guard let sessionEnd = sessionEnd else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        guard let date = parser.date(from: sessionEnd) else {
            return nil
        }
        
        return formatter.string(from: date)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case uid = "cdr_uid"
        case idCpo = "cdr_id_cpo"
        case authMode = "media"
        case sessionStart = "cdr_session_start"
        case sessionEnd = "cdr_session_end"
        case street = "street"
        case postalCode = "postal_code"
        case city = "city"
        case country = "country"
        case latitude = "latitude"
        case longitude = "longitude"
        case consumedEnergy = "consumed_energy"
        case consumedTime = "consumed_time"
        case odometerValue = "odometer_value"
        case cdrTypeRaw = "type"
        case evseId = "evse_id"
        case operatorName = "operator_name"
    }
}

struct CdrStats: Decodable {
    let totalTime: Int
    let totalEnergy: Double
    
    enum CodingKeys: String, CodingKey {
        case totalTime = "total_time"
        case totalEnergy = "total_energy"
    }
}

