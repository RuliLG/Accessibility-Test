//
//  AuthenticationModesHelper.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 15/1/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import UIKit

enum AuthenticationType: String {
    case App = "app"
    case FuelChargeCard = "card"
    case Unknown = ""
}

func getAuthenticationLocalizedName(from auth: AuthenticationType) -> String {
    switch auth {
    case .App:
        return SchemeHelper.localizedText(forKey: "filter_payment_app")
    case .FuelChargeCard:
        return SchemeHelper.localizedText(forKey: "filter_payment_card")
    case .Unknown:
        return SchemeHelper.localizedText(forKey: "detail_unknown")
    }
}

func getAuthenticationImage(for auth: AuthenticationType) -> UIImage {
    switch auth {
    case .App:
        return UIImage(named: "ic_media_app")!
    case .FuelChargeCard:
        return UIImage(named: "ic_media_card")!
    case .Unknown:
        return UIImage(named: "icon_unknown")!
    }
}

func transformAcceptanceMediaToAPIString(_ media: [AuthenticationType]) -> String? {
    if media.isEmpty { return nil }
    
    var apiString: [String] = []
    
    media.forEach { mediaType in
        apiString.append(mediaType.rawValue)
    }
    
    return apiString.joined(separator: ",")
}

func getAuthType(from value: String) -> AuthenticationType {
    if value == "" {
        return .Unknown
    }

    return value.lowercased() == "card" ? .FuelChargeCard : .App
}
