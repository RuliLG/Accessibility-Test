//
//  UtcTime.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 9/6/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

func getUtcTimeString(_ date: Date? = nil) -> String {
    let date = date ?? Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    let utcTimeZoneStr = formatter.string(from: date)
    return utcTimeZoneStr
}
