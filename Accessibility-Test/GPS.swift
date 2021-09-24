//
//  GPS.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 20/4/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import CoreLocation
import UIKit

func isGpsEnabled() -> Bool {
    return CLLocationManager.locationServicesEnabled()
}

func hasGpsAccess() -> Bool {
    if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
            break
        }
    }
    
    return false
}

func openAppSettings() {
    if let bundleId = Bundle.main.bundleIdentifier {
        UIApplication.shared.open(URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")!)
    } else {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
