//
//  ChargepointPrice.swift
//  eChargeApp
//
//  Created by David Amo on 29/03/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import UIKit

enum PriceType {
    case PerSession
    case PerKwh
    case Parking
    case PerMinute
    case StartingFee
    case PerHour
}

class Price {
    let type: PriceType
    let price: String?
    let spanPrice: [String?]?
    let currency: String?
    
    init(_ type: PriceType, _ price: String, _ currency: String) {
        self.type = type
        self.price = price
        self.spanPrice = nil
        self.currency = currency
    }
    
    init(type: PriceType, spanPrice: [String]?, currency: String) {
        self.type = type
        self.price = nil
        self.spanPrice = spanPrice
        self.currency = currency
    }

    func text() -> String {
        return SchemeHelper.localizedText(forKey: getTextName())
    }
    
    func image() -> UIImage? {
        let name = getImageName()
        return UIImage(named: name)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
    
    func getSimplifiedPrice() -> String {
        if self.type == .PerHour {
            return "\(self.formattedPrice()) / \(SchemeHelper.localizedText(forKey: "map_price_per_hour"))"
        }
        
        if  self.type == .PerMinute {
            return "\(self.formattedPrice()) / \(SchemeHelper.localizedText(forKey: "map_price_per_minute"))"
        }

        if self.type == .PerKwh {
            return "\(self.formattedPrice()) / kWh"
        }
        
        if self.type == .PerSession {
            return "\(self.formattedPrice()) / \(SchemeHelper.localizedText(forKey: "map_price_per_session"))"
        }

        return formattedPrice()
    }
    
    func formattedPrice() -> String {
        guard let price = self.price else {
            if let firstPrice = self.spanPrice?[0] {
                return "\(firstPrice)"
            }
            
            return SchemeHelper.localizedText(forKey: "common_click_here_more_details")
        }
        
        return "\(price) \(self.currency ?? "")"
    }
    
    private func getImageName() -> String {
        switch type {
        case .Parking:
            return "ic_parking"
        case .PerHour:
            return "ic_time"
        case .PerKwh:
            return "ic_flash"
        case .PerMinute:
            return "ic_time"
        case .PerSession:
            return "ic_label_ios"
        case .StartingFee:
            return "ic_label_ios"
        }
    }
    
    private func getTextName() -> String {
        switch type {
        case .Parking:
            return "detail_price_per_parking"
        case .PerHour:
            return "detail_price_per_hour"
        case .PerKwh:
            return "detail_price_per_kwh"
        case .PerMinute:
            return "detail_price_per_minute"
        case .PerSession:
            return "detail_price_per_session"
        case .StartingFee:
            return "detail_price_starting_fee"
        }
    }
}
