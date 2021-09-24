//
//  Duration.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 12/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Foundation

class Duration {
    enum DurationFormat {
        case long, short
    }

    static func from(seconds: Int, format: DurationFormat = .long) -> String {
        let days = (seconds % 31536000 / 86400, SchemeHelper.localizedText(forKey: "duration_day"), SchemeHelper.localizedText(forKey: "duration_days"), "d")
        let hours = (seconds % 86400 / 3600, SchemeHelper.localizedText(forKey: "duration_hour"), SchemeHelper.localizedText(forKey: "duration_hours"), "h")
        let minutes = (seconds % 3600 / 60, SchemeHelper.localizedText(forKey: "duration_minute"), SchemeHelper.localizedText(forKey: "duration_minutes"), "m")

        let fullDate = [days, hours, minutes]
        let multiValueString = fullDate
            .map({ (value, singular, plural, english) in
                switch format {
                case .short:
                    return "\(value)\(english)"
                case .long:
                    return "\(value) \(value == 1 ? singular : plural)"
                }
            })
            .joined(separator: " ")
        return multiValueString
    }
}
