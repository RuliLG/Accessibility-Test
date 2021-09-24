//
//  LocationModel.swift
//  eChargeApp
//
//  Created by Merino Fajardo García on 04/08/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import UIKit

// MARK: - Token
struct Token: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

// MARK: - Location
struct LocationModel: Decodable {
    let id: String
    let idCpo: String?
    let operatorID: String?
    let name: String?
    let country: String?
    let city: String?
    let street: String?
    let postalCode: String?
    let houseNum: String?
    let floor: String?
    let region: String?
    let timezone: String?
    let latitude: Double
    let longitude: Double
    let isOpen24_7: Bool?
    let chargingWhenClosed: Bool?
    let source: String?
    let md5Hash: String?
    let lastUpdated: String?
    let evses: [Evse]
    let networkStationOperator: Operator?
    let userDistance: Double?
    let accessibility: String?
    let facility: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idCpo = "id_cpo"
        case operatorID = "operator_id"
        case name = "name"
        case country = "country"
        case city = "city"
        case street = "street"
        case postalCode = "postal_code"
        case houseNum = "house_num"
        case floor = "floor"
        case region = "region"
        case timezone = "timezone"
        case latitude = "latitude"
        case longitude = "longitude"
        case isOpen24_7 = "is_open_24_7"
        case chargingWhenClosed = "charging_when_closed"
        case source = "source"
        case md5Hash = "md5_hash"
        case lastUpdated = "last_updated"
        case evses = "evses"
        case networkStationOperator = "operator"
        case userDistance = "userDistance"
        case accessibility = "accessibility"
        case facility = "facility"
    }
}

struct RemoteResponse: Decodable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "message"
    }
}

// MARK: - Evse
struct Evse: Decodable {
    let id: String?
    let locationID: String?
    let evseID: String
    let uid: String?
    let status: String?
    let authModes: String?
    let md5Hash: String?
    let lastUpdated: String?
    let source: String?
    let connectors: [Connector]?
    let openingTimes: [TimeFrame]?
    let parkingRestriction: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case locationID = "location_id"
        case evseID = "evse_id"
        case uid = "uid"
        case status = "status"
        case authModes = "auth_modes"
        case md5Hash = "md5_hash"
        case lastUpdated = "last_updated"
        case source = "source"
        case connectors = "connectors"
        case openingTimes = "openingTimes"
        case parkingRestriction = "parking_restriction"
    }
    
    func canRemoteCharging() -> Bool {
        guard let authModes = authModes else {
            return false
        }

        return authModes.lowercased().contains("remote")
    }
    
    func canPayWithCard() -> Bool {
        guard let authModes = authModes else {
            return false
        }

        return authModes.lowercased().contains("rfid")
    }
    
    func isAuthModeNilOrEmpty() -> Bool {
        let isNil = authModes == nil
        let isEmpty = authModes == ""
        
        return isNil || isEmpty
    }
    
    func canStartCharging() -> Bool {
        return canRemoteCharging() && status?.lowercased() == "available"
    }
}

// MARK: - Evse Check
struct EvseCheck: Decodable {
    let id: String
    let locationId: String
    let evseId: String
    let uid: String
    let status: String
    let authModes: String
    let source: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case locationId = "location_id"
        case evseId = "evse_id"
        case uid = "uid"
        case status = "status"
        case authModes = "auth_modes"
        case source = "source"
    }
}

// MARK: - Connector
struct Connector: Decodable {
    let id: String
    let evseUid: String?
    let idCpo: String?
    let plugType: String?
    let powerType: String?
    let voltage: Int?
    let amperage: Int?
    let power: Double?
    let md5Hash: String?
    let lastUpdated: String?
    let source: String?
    let prices: [PriceV2]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case evseUid = "evse_uid"
        case idCpo = "id_cpo"
        case plugType = "plug_type"
        case powerType = "power_type"
        case voltage = "voltage"
        case amperage = "amperage"
        case power = "power"
        case md5Hash = "md5_hash"
        case lastUpdated = "last_updated"
        case source = "source"
        case prices = "prices"
    }
}


// MARK: - Price
struct PriceV2: Decodable {
    let type: String?
    let stepSize: Int?
    let currency: String?
    let price: String?
    let startTime: String?
    let endTime: String?
    let minDuration: Int?
    let maxDuration: Int?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case stepSize = "step_size"
        case currency = "currency"
        case price = "price"
        case startTime = "start_time"
        case endTime = "end_time"
        case minDuration = "min_duration"
        case maxDuration = "max_duration"
    }
}

class PriceV2Group {
    private var prices: [PriceV2] = []
    
    func add(_ price: PriceV2) {
        prices.append(price)
    }
    
    func get() -> [PriceV2] {
        // Check if there are more than 0 prices
        var nonZeroPrices = 0
        for price in prices {
            if (price.price! as NSString).floatValue > 0 {
                nonZeroPrices += 1
            }
        }
        
        if nonZeroPrices > 0 {
            return prices.filter { (price) -> Bool in
                return (price.price! as NSString).floatValue > 0
            }
        }
    
        return prices
    }
}

// MARK: - Operator
struct Operator: Decodable {
    let name: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

// MARK: - TimeFrame
struct TimeFrame: Decodable {
    let weekday: Int?
    let begin: String?
    let end: String?
    
    enum CodingKeys: String, CodingKey {
        case weekday = "weekday"
        case begin = "begin"
        case end = "end"
    }
}

// MARK: - State
struct StateResponse: Decodable {
    let state: String
    let error: ErrorWithCode?

    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error = "error"
    }
}

struct IdpResponse: Decodable {
    let idpError: IdpError?

    enum CodingKeys: String, CodingKey {
        case idpError = "idpError"
    }
}

struct IdpError: Decodable {
    let errorCode: Int
    let errorMessage: IdpErrorMessage
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorCode"
        case errorMessage = "errorMessage"
    }
}

struct IdpErrorMessage: Decodable {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "errorMessage"
    }
}

struct ErrorWithCode: Decodable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
}

// MARK: - OTP
struct User: Decodable {
    var token: String?
    var firstName: String
    var lastName: String
    let email: String
    let cardNumber: String
    let expiryDate: String
    let emaId: String
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
        case cardNumber = "cardNumber"
        case expiryDate = "expiryDate"
        case emaId = "EMA-ID"
        case uid = "UID"
    }
}

struct FavoriteModel: Decodable {
    let id: String
    let userId: String
    let locationId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case locationId = "location_id"
    }
}

struct UserAttributesModel: Decodable {
    let provider: String?
    let vehicleId: String?
    let systemsOfUnits: String?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case provider = "provider"
        case vehicleId = "vehicleId"
        case systemsOfUnits = "systemsOfUnits"
        case language = "language"
    }
}
