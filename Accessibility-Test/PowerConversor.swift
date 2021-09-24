//
//  PowerConversor.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 25/2/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

class PowerConversor {
    static func toWh(from hp: Double) -> Double {
        return hp / 1.34102
    }
    
    static func toHp(from wh: Double) -> Double {
        return wh * 1.34102
    }
}
