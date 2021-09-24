//
//  DistanceHelper.swift
//  eChargeApp
//
//  Created by Merino Fajardo García on 02/11/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation

class DistanceHelper {
    static func displayDistanceWithUserPreference(_ distance: Double, decimals: Int = 2) -> String {
        var distanceValue: Double = 0
        var distanceUnit = DistanceUnit.kilometers
        
        if distance < 1 {
            distanceUnit = .meters
            distanceValue = distance * 1000
        } else {
            distanceValue = distance
            distanceUnit = .kilometers
        }
        
        distanceValue = distanceValue.round(toPlaces: decimals)
        
        switch distanceUnit {
        case .meters:
            return decimals == 0 ? "\(Int(distanceValue)) m" : "\(distanceValue) m"
        case .kilometers:
            return decimals == 0 ? "\(Int(distanceValue)) km" : "\(distanceValue) km"
        case .miles:
            return (decimals == 0 ? "\(Int(distanceValue)) " : "\(distanceValue) ") + SchemeHelper.localizedText(forKey: "distance_miles")
        }
    }
}

enum DistanceUnit {
    case meters
    case kilometers
    case miles
}
