//
//  ConsumptionHelper.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 25/2/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

class ConsumptionHelper {
    static func displayWithUserPreference(_ consumption: Double) -> String {
        let c = format(consumption)
        return "\(c)/100km"
    }
    
    static func format(_ consumption: Double) -> String {
        return "\(Int(consumption.rounded())) kWh"
    }
}
