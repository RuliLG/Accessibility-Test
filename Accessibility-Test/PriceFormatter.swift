//
//  PriceFormatter.swift
//  eChargeApp
//
//  Created by Merino Fajardo García on 26/10/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation
class PriceFormatter {
    static func format (_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: price as NSNumber)!
    }
}
