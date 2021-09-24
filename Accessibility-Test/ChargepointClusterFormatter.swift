//
//  ChargepointClusterFormatter.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 24/5/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

class ChargepointClusterFormatter {
    struct Factor {
        var min: Int
        var factor: Int
    }
    
    static func format (_ n: Int) -> String {
        let factors = [
            Factor(min: 100_000, factor: 50_000),
            Factor(min: 10_000, factor: 5_000),
            Factor(min: 1_000, factor: 1_000),
            Factor(min: 100, factor: 100)
        ]
        
        for factor in factors {
            if n >= factor.min {
                let multiplier = Int(n / factor.factor)
                return "\(multiplier * factor.factor)+"
            }
        }
        
        if n >= 50 {
            return "50+"
        }
        
        if n >= 20 {
            return "20+"
        }
        
        return "\(n)"
    }
}
