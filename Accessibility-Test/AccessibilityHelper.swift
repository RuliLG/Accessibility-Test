//
//  AccessibilityHelper.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 10/2/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

func getLocalizedAccessibilities(from string: String) -> [String] {
    let separated = string.components(separatedBy: ",")
    var result: [String] = []
    for string in separated {
        if let localized = getLocalizedAccessibility(from: string) {
            result.append(localized)
        }
    }
    
    return result
}

func getLocalizedAccessibility(from string: String) -> String? {
    switch string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
    case "free publicly accessible":
        return SchemeHelper.localizedText(forKey: "additional_location_free_publicly_accessible")
    case "restricted access":
        return SchemeHelper.localizedText(forKey: "additional_location_restricted_access")
    case "paying publicly accessible":
        return SchemeHelper.localizedText(forKey: "additional_location_paid_publicly_accessible")
    case "test station":
        return SchemeHelper.localizedText(forKey: "additional_location_test_station")
    case "on_street":
        return SchemeHelper.localizedText(forKey: "additional_location_on_street")
    case "parking_garage":
        return SchemeHelper.localizedText(forKey: "additional_location_parking_garage")
    case "underground_garage":
        return SchemeHelper.localizedText(forKey: "additional_location_underground_garage")
    case "parking_lot":
        return SchemeHelper.localizedText(forKey: "additional_location_parking_lot")
    default:
        return nil
    }
}

func getLocalizedFacilities(from string: String) -> [String] {
    let separated = string.components(separatedBy: ",")
    var result: [String] = []
    for string in separated {
        if let localized = getLocalizedFacility(from: string) {
            result.append(localized)
        }
    }
    
    return result
}

func getLocalizedFacility(from string: String) -> String? {
    switch string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
    case "hotel":
        return SchemeHelper.localizedText(forKey: "additional_location_hotel")
    case "restaurant":
        return SchemeHelper.localizedText(forKey: "additional_location_restaurant")
    case "cafe":
        return SchemeHelper.localizedText(forKey: "additional_location_cafe")
    case "mall":
        return SchemeHelper.localizedText(forKey: "additional_location_mall")
    case "supermarket":
        return SchemeHelper.localizedText(forKey: "additional_location_supermarket")
    case "sport":
        return SchemeHelper.localizedText(forKey: "additional_location_sport")
    case "recreation_area":
        return SchemeHelper.localizedText(forKey: "additional_location_recreation_area")
    case "nature":
        return SchemeHelper.localizedText(forKey: "additional_location_nature")
    case "museum":
        return SchemeHelper.localizedText(forKey: "additional_location_museum")
    case "bus_stop":
        return SchemeHelper.localizedText(forKey: "additional_location_bus_stop")
    case "taxi_stand":
        return SchemeHelper.localizedText(forKey: "additional_location_taxi_stand")
    case "train_station":
        return SchemeHelper.localizedText(forKey: "additional_location_train_station")
    case "airport":
        return SchemeHelper.localizedText(forKey: "additional_location_airport")
    case "carpool_parking":
        return SchemeHelper.localizedText(forKey: "additional_location_carpool_parking")
    case "fuel_station":
        return SchemeHelper.localizedText(forKey: "additional_location_fuel_station")
    case "wifi":
        return SchemeHelper.localizedText(forKey: "additional_location_wifi")
    default:
        return nil
    }
}

func getLocalizedParkingRestrictions(from string: String) -> [String] {
    let separated = string.components(separatedBy: ",")
    var result: [String] = []
    for string in separated {
        if let localized = getLocalizedParkingRestriction(from: string) {
            result.append(localized)
        }
    }
    
    return result
}

func getLocalizedParkingRestriction(from string: String) -> String? {
    switch string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
    case "ev_only":
        return SchemeHelper.localizedText(forKey: "additional_location_ev_only")
    case "plugged":
        return SchemeHelper.localizedText(forKey: "additional_location_plugged")
    case "disabled":
        return SchemeHelper.localizedText(forKey: "additional_location_disabled")
    case "customers":
        return SchemeHelper.localizedText(forKey: "additional_location_customers")
    case "motorcycles":
        return SchemeHelper.localizedText(forKey: "additional_location_motorcycles")
    default:
        return nil
    }
}
