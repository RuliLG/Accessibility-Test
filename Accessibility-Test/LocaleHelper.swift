//
//  LocaleHelper.swift
//  eChargeApp
//
//  Created by Trafineo on 30/03/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation

class LocaleHelper {
    static func countryName(forKey: String) -> String{
        let currentLanguage = NSLocale.current.languageCode
        let locale = NSLocale(localeIdentifier: currentLanguage ?? "DE")
        return locale.displayName(forKey: NSLocale.Key.countryCode, value: forKey) ?? ""
    }
    
    static func getFormattedDistance(distance: Double, decimals: Int = 2) -> String {
        return DistanceHelper.displayDistanceWithUserPreference(distance, decimals: decimals)
    }
    
    static func isUk() -> Bool {
        let countryCode = NSLocale.current.languageCode?.uppercased()

        return countryCode == "GB" || countryCode == "GBR"
    }
    
    static func getFormattedSpeed(speed: Double) -> String {
        if isUk() {
            let factor = 0.62
            return "\(NSString(format: "%.1f", speed * factor)) mph"
        }
        
        return "\(NSString(format: "%.1f", speed)) km/h"
    }
    
    static func getFormattedPower(_ power: Double, includeHp: Bool = true, decimals: Int = 1) -> String {
        if includeHp {
            let hp = PowerConversor.toHp(from: power)
            return "\(NSString(format: "%.\(decimals)f" as NSString, power)) kW (\(NSString(format: "%.0f", hp)) hp)"
        } else {
            return "\(NSString(format: "%.\(decimals)f" as NSString, power)) kW"
        }
    }
    
    static func getFormattedKwh(_ energy: Double, decimals: Int = 1) -> String {
        return "\(NSString(format: "%.\(decimals)f" as NSString, energy)) kWh"
    }
}
