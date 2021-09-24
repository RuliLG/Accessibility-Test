//
//  NetworkService.swift
//  eChargeApp
//
//  Created by Merino Fajardo García on 03/06/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation
import MapKit

typealias SuccessfulHandler = (Result<Bool, Error>) -> Void
typealias ResponseCodeHandler = (Result<Int, Error>) -> Void
typealias ClusterHandler = (Result<[ClusterModel], Error>) -> Void
typealias EvseHandler = (Result<Evse, Error>) -> Void
typealias EvseCheckHandler = (Result<EvseCheck, Error>) -> Void
typealias UserHandler = (Result<User, Error>) -> Void
typealias LogoutHandler = (Result<Bool, Error>) -> Void
typealias DeleteUserHandler = (Result<Bool, Error>) -> Void
typealias LocationsHandler = (Result<[LocationModel], Error>) -> Void
typealias LocationHandler = (Result<LocationModel, Error>) -> Void
typealias FavoritesHandler = (Result<FavoriteModel, Error>) -> Void
typealias DeleteFavoriteHandler = (Result<Bool, Error>) -> Void
typealias StateHandler = (Result<StateResponse, Error>) -> Void
typealias VersioningHandler = (Result<VersioningModel, Error>) -> Void
typealias RemoteHandler = (Result<RemoteResponse, Error>) -> Void
typealias StorePushNotificationTokenHandler = (Result<Bool, Error>) -> Void
typealias VehiclesHandler = (Result<[Vehicle], Error>) -> Void
typealias VehicleHandler = (Result<Vehicle, Error>) -> Void
typealias StoreVehicleHandler = (Result<Bool, Error>) -> Void
typealias UserAttributesHandler = (Result<UserAttributesModel, Error>) -> Void
typealias ResultHandler = (Result<ResultResponse, Error>) -> Void
typealias CdrListHandler = (Result<CdrList, Error>) -> Void
typealias CdrHandler = (Result<Cdr, Error>) -> Void
typealias CdrStatsHandler = (Result<CdrStats, Error>) -> Void

enum ResponseCode: Error {
    case decodingWentWrong
    case badStatus
    case notFound
    case unauthorized
    case serverError
    case alreadyRegistered
}

class NetworkService {
    private let HTTP_OK_CODE = 200
    private let HTTP_OK_NO_CONTENT_CODE = 204
    private let API = APIManager.shared
    private let loadingToast = LoadingToastView.instanceFromNib()
    
    // MARK: - Login
    func loginWithEmail(email: String, password: String, then completionHandler: @escaping UserHandler) {
        
        API.provider.request(.login(email: email, password: password))
        { (result) in
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseLoginData(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.display(for: statusCode, name: nil)
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func logout(token: String, then completionHandler: @escaping LogoutHandler) {
        displayLoadingToast()
        
        API.provider.request(.logout(token: token)) { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let code = response.response?.statusCode
                let isCodeValid = code == self.HTTP_OK_CODE || code == self.HTTP_OK_NO_CONTENT_CODE
                completionHandler(.success(isCodeValid))
            }
        }
    }
    
    func forgotPassword(email: String, then completionHandler: @escaping StateHandler) {
        displayLoadingToast()
        
        API.provider.request(.forgotPassword(email: email))
        { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    completionHandler(Result.success(StateResponse(state: "successful", error: nil)))
                } else {
                    NetworkErrorHandler.shared.display(for: statusCode, name: nil)
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func changePassword(
        old: String,
        new: String,
        then completionHandler: @escaping SuccessfulHandler)
    {
        API.provider.request(.changePassword(old: old, new: new))
        { (result) in
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    completionHandler(.success(true))
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "changePassword") {
                        self.changePassword(old: old, new: new, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
                }
            }
        }
    }

    // MARK: - Clusters
    
    func fetchClusters(then completionHandler: @escaping ClusterHandler) {
        
        API.provider.request(.clusters())
        { (result) in
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseClustersResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchClusters") {
                        self.fetchClusters(then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    // MARK: - Favorites
    
    func fetchFavoriteLocations(then completionHandler: @escaping LocationsHandler) {
        guard let _ = MainViewModel.user else {
            completionHandler(.failure(ResponseCode.unauthorized))
            return
        }
        
        let userLocation = MainViewModel.userLocation

        displayLoadingToast()
        API.provider.request(.getFavorites(userLocation: userLocation)) { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseLocationsResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchFavoriteLocations") {
                        self.fetchFavoriteLocations(then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func markAsFavorite(locationId: String, then completionHandler: @escaping FavoritesHandler) {
        guard MainViewModel.user != nil else {
            completionHandler(.failure(ResponseCode.unauthorized))
            return
        }

        displayLoadingToast()
        API.provider.request(.markAsFavorite(locationId: locationId)) { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseMarkAsFavoriteResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "markAsFavorite") {
                        self.markAsFavorite(locationId: locationId, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func deleteFavorite(locationId: String, then completionHandler: @escaping DeleteFavoriteHandler) {
        guard MainViewModel.user != nil else {
            completionHandler(.failure(ResponseCode.unauthorized))
            return
        }

        displayLoadingToast()
        API.provider.request(.deleteFavorite(locationId: locationId)) { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == 200 {
                    completionHandler(.success(true))
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "markAsFavorite") {
                        self.deleteFavorite(locationId: locationId, then: completionHandler)
                    } catch: {
                        completionHandler(.success(false))
                    }
                }
            }
        }
    }
    
    // MARK: - Remote
    func startRemoteCharging(evseId: String, timestamp: Int, then completionHandler: @escaping RemoteHandler) {
        displayLoadingToast()
        
        API.provider.request(.startChargingSession(evseId: evseId, timestamp: timestamp))
        { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseRemoteResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "startRemoteCharging") {
                        self.startRemoteCharging(evseId: evseId, timestamp: timestamp, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func stopRemoteCharging(evseId: String, timestamp: Int, then completionHandler: @escaping RemoteHandler) {
        displayLoadingToast()
        
        API.provider.request(.stopChargingSession(evseId: evseId, timestamp: timestamp))
        { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseRemoteResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "stopRemoteCharging") {
                        self.stopRemoteCharging(evseId: evseId, timestamp: timestamp, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func getChargingStatus(timestamp: Int, userUid: String, then completionHandler: @escaping RemoteHandler) {
        displayLoadingToast()
        
        API.provider.request(.getChargingSessionStatus(timestamp: timestamp, userUid: userUid))
        { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseRemoteResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "getChargingStatus") {
                        self.getChargingStatus(timestamp: timestamp, userUid: userUid, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    // MARK: - Locations
    
    func fetchNearbyLocations(
        mapLocation: CLLocationCoordinate2D,
        radius: Int = 200,
        maxResults: Int = 1000,
        isMap: Bool = false,
        then completionHandler: @escaping LocationsHandler)
    {
        let userLocation = MainViewModel.userLocation
        
        var available = false
        var plugs: [PlugType] = []
        var authModes: [AuthenticationType] = []
        var power: Float? = nil
        var minPower: Float? = nil
        var maxPower: Float? = nil
        
        if let filterSettings = RealmManager.shared.getLastFilters() {
            let activated = filterSettings.plugsActivated.components(separatedBy: ",")
            activated.forEach { plugName in
                plugs.append(getPlugType(from: plugName))
            }
            
            let media = filterSettings.acceptanceMedia.components(separatedBy: ",").filter { $0.count > 0 }
            media.forEach { authMode in
                authModes.append(getAuthType(from: authMode))
            }

            available = filterSettings.showOnlyAvailable
            if filterSettings.chargingPower > 0 {
                power = filterSettings.chargingPower
            }
            if filterSettings.chargingPowerMin > PowerSlideState.all.rawValue {
                minPower = filterSettings.chargingPowerMin
            }
            if filterSettings.chargingPowerMax < PowerSlideState.threehundred.rawValue {
                maxPower = filterSettings.chargingPowerMax
            }
        }
        
        API.provider.request(.nearbyLocations(
            mapLocation: mapLocation,
            userLocation: userLocation,
            plugs: transformPlugsTypeToAPIString(plugs),
            authModes: transformAcceptanceMediaToAPIString(authModes),
            available: available,
            chargePower: power,
            chargePowerMin: minPower,
            chargePowerMax: maxPower,
            radius: radius,
            maxResults: maxResults,
            isMap: isMap))
        { (result) in
            
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                case .success(let response):
                    let statusCode = response.response?.statusCode ?? 0
                    if statusCode == self.HTTP_OK_CODE {
                        let result = self.parseLocationsResponse(response.data)
                        completionHandler(result)
                    } else {
                        NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchNearbyLocations") {
                            self.fetchNearbyLocations(mapLocation: mapLocation, radius: radius, maxResults: maxResults, isMap: isMap, then: completionHandler)
                        } catch: {
                            completionHandler(.failure(ResponseCode.decodingWentWrong))
                        }
                    }
                }
        }
    }
    
    func fetchLocationDetails(
        locations: [String],
        then completionHandler: @escaping LocationsHandler)
    {
        let userLocation = MainViewModel.userLocation
        
        displayLoadingToast()
        
        API.provider.request(.locationDetails(
            userLocation: userLocation,
            locations: locations))
        { (result) in
            self.hideLoadingToast()
            
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                case .success(let response):
                    let statusCode = response.response?.statusCode ?? 0
                    if statusCode == self.HTTP_OK_CODE {
                        let result = self.parseLocationsResponse(response.data)
                        completionHandler(result)
                    } else {
                        NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchLocationDetails") {
                            self.fetchLocationDetails(locations: locations, then: completionHandler)
                        } catch: {
                            completionHandler(.failure(ResponseCode.badStatus))
                        }
                    }
                }
        }
    }
    
    func fetchLocation(
        locationId: String,
        then completionHandler: @escaping LocationHandler)
    {
        let _ = MainViewModel.userLocation
        
        displayLoadingToast()
        
        API.provider.request(.location(id: locationId))
        { (result) in
            self.hideLoadingToast()
            
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                case .success(let response):
                    let statusCode = response.response?.statusCode ?? 0
                    if statusCode == self.HTTP_OK_CODE {
                        let result = self.parseLocationResponse(response.data)
                        completionHandler(result)
                    } else {
                        NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchLocation") {
                            self.fetchLocation(locationId: locationId, then: completionHandler)
                        } catch: {
                            completionHandler(.failure(ResponseCode.badStatus))
                        }
                    }
                }
        }
    }
    
    func fetchEvseId(
        _ evseId: String,
        then completionHandler: @escaping EvseCheckHandler)
    {
        displayLoadingToast()
        
        API.provider.request(.checkEvseId(evseId: evseId))
        { (result) in
            self.hideLoadingToast()
            
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                case .success(let response):
                    let statusCode = response.response?.statusCode ?? 0
                    if statusCode == self.HTTP_OK_CODE {
                        let result = self.parseEvseCheckResponse(response.data)
                        completionHandler(result)
                    } else {
                        NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchEvseId") {
                            self.fetchEvseId(evseId, then: completionHandler)
                        } catch: {
                            completionHandler(.failure(ResponseCode.notFound))
                        }
                    }
                }
        }
    }
    
    // MARK: - Users
    
    func fetchUser(token: String, then completionHandler: @escaping UserHandler) {
        displayLoadingToast()
        
        API.provider.request(.user(token: token)) { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseLoginData(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchUser") {
                        self.fetchUser(token: token, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func editUser(
        name: String,
        surname: String,
        then completionHandler: @escaping SuccessfulHandler)
    {
        API.provider.request(.editUser(name: name, surname: surname))
        { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == 200 {
                    completionHandler(.success(true))
                } else if (400...499).contains(statusCode) {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "editUser") {
                        self.editUser(name: name, surname: surname, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
                } else {
                    NetworkErrorHandler.shared.display(for: statusCode, name: nil)
                    completionHandler(.failure(ResponseCode.serverError))
                }
            }
        }
    }
    
    func deleteUser(then completionHandler: @escaping SuccessfulHandler) {
        displayLoadingToast()
        
        API.provider.request(.deleteUser) { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_NO_CONTENT_CODE {
                    completionHandler(.success(true))
                } else if (400...499).contains(statusCode) {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "deleteUser") {
                        self.deleteUser(then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
                } else {
                    NetworkErrorHandler.shared.display(for: statusCode, name: nil)
                    completionHandler(.failure(ResponseCode.serverError))
                }
            }
        }
    }
    
    func getUserAttributes(then completionHandler: @escaping UserAttributesHandler) {
        API.provider.request(.getUserAttributes) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseUserAttributesResponse(response.data)
                    completionHandler(result)
                } else {
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func storeUserAttributes(includeSystemOfUnits: Bool, then completionHandler: @escaping SuccessfulHandler) {
        let preference = RealmManager.shared.fetch(RealmUserPreferences.self).first
        let provider = isAralScheme ? "aral" : "bp"
        let systemsOfUnits = includeSystemOfUnits ? (preference == nil || preference?.useKilometers == true ? "metrical" : "imperial") : nil
        let language = NSLocale.current.languageCode ?? "de"
        let rawVehicleId = MainViewModel.user?.vehicle?.vehicleID
        let vehicleId = rawVehicleId == nil ? nil : String(rawVehicleId!)
        
        let requestData: APIEndpoints = .storeUserAttributes(provider: provider, systemsOfUnits: systemsOfUnits, language: language, vehicleId: vehicleId)
        API.provider.request(requestData) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    completionHandler(.success(true))
                } else if (400...499).contains(statusCode) {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "storeUserAttributes") {
                        self.storeUserAttributes(includeSystemOfUnits: includeSystemOfUnits, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
                } else {
                    NetworkErrorHandler.shared.display(for: statusCode, name: nil)
                    completionHandler(.failure(ResponseCode.serverError))
                }
            }
        }
    }
    
    func storePushNotificationToken(registrationId: String, userUid: String, isActive: Bool, then completionHandler: @escaping StorePushNotificationTokenHandler) {
        API.provider.request(.storePushNotificationToken(
            registrationId: registrationId,
            userUid: userUid,
            isActive: isActive)) { (result) in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let response):
                    if response.response?.statusCode == self.HTTP_OK_CODE {
                        completionHandler(.success(true))
                    } else {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
                }
            }
    }
    
    func fetchNewToken(
        oldToken: String,
        then completionHandler: @escaping (Result<Token, Error>) -> Void)
    {
        API.provider.request(.refreshToken(token: oldToken))
        { (result) in
            switch result {
            case.failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                if response.statusCode == self.HTTP_OK_CODE {
                    let result = self.parseTokenResponse(response.data)
                    completionHandler(result)
                } else if response.statusCode == 401 {
                    completionHandler(.failure(ResponseCode.unauthorized))
                } else {
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func validateCardNumber(
        cardNumber: String,
        expiryMonth: String,
        expiryYear: String,
        then completionHandler: @escaping StateHandler)
    {
        API.provider.request(.cardAvailable(cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear))
        { (result) in
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 200
                switch statusCode {
                case self.HTTP_OK_CODE:
                    let response = self.parseStatusResponse(response.data)
                    switch response {
                    case .failure:
                        completionHandler(.success(StateResponse(state: "successful", error: nil)))
                    case .success(let state):
                        print(state)
                        if let error = state.error {
                            NetworkErrorHandler.shared.handle(with: error.code, key: "validateCardNumber") {
                                // ...
                            } catch: {
                                completionHandler(.failure(ResponseCode.badStatus))
                            }

                        } else {
                            completionHandler(.success(state))
                        }
                    }
                case 400...500:
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "validateCardNumber") {
                        self.validateCardNumber(cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(statusCode == 418 ? ResponseCode.alreadyRegistered : ResponseCode.badStatus))
                    }
                default:
                    completionHandler(.failure(ResponseCode.badStatus))
                }
            }
        }
    }
    
    // MARK: - Registration / OTP
    
    func register(
        firstName: String,
        lastName: String,
        email: String,
        cardNumber: String,
        expiryMonth: String,
        expiryYear: String,
        accept: Bool,
        then completionHandler: @escaping StateHandler)
    {
        let expiryDate = String(expiryMonth.padding(toLength: 2, withPad: "0", startingAt: 0).prefix(2)) + String(expiryYear.padding(toLength: 2, withPad: "0", startingAt: 0).prefix(2))
        displayLoadingToast()
        
        API.provider.request(.register(firstName: firstName, lastName: lastName, email: email, cardNumber: cardNumber, expiryDate: expiryDate, accept: accept))
        { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let response = self.parseStatusResponse(response.data)
                    switch response {
                    case .failure:
                        completionHandler(.success(StateResponse(state: "successful", error: nil)))
                    case .success(let state):
                        if let error = state.error {
                            NetworkErrorHandler.shared.handle(with: error.code, key: "register") {
                                // ...
                            } catch: {
                                completionHandler(.failure(ResponseCode.badStatus))
                            }

                        } else {
                            completionHandler(.success(state))
                        }
                    }
                } else {
                    let parseStatus = self.parseStatusResponse(response.data)
                    switch parseStatus {
                    case .failure:
                        let parseIdp = self.parseIdpResponse(response.data)
                        switch parseIdp {
                        case .failure:
                            completionHandler(.failure(ResponseCode.badStatus))
                        case .success(let responseIdp):
                            if let idpError = responseIdp.idpError {
                                NetworkErrorHandler.shared.display(for: idpError.errorCode, name: nil)
                            }
                        }
                    case .success(let responseStatus):
                        if let statusError = responseStatus.error {
                            NetworkErrorHandler.shared.display(for: statusError.code, name: nil)
                        }
                    }
/*
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "register") {
                        self.register(firstName: firstName, lastName: lastName, email: email, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, accept: accept, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
*/
                }
            }
        }
    }
    
    func verifyOtp(
        otpCode: String,
        email: String,
        password: String,
        firstLogin: Bool,
        then completionHandler: @escaping UserHandler)
    {
        displayLoadingToast()
        
        API.provider.request(.verifyOtp(otpCode: otpCode, email: email, password: password, firstLogin: firstLogin))
        { (result) in
            self.hideLoadingToast()
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                switch statusCode {
                case self.HTTP_OK_CODE:
                    let result = self.parseUserResponse(response.data)
                    completionHandler(result)
                case 400...500:
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "verifyOtp") {
                        self.verifyOtp(otpCode: otpCode, email: email, password: password, firstLogin: firstLogin, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.badStatus))
                    }
                default:
                    let toast = InfoToastView.instanceFromNib()
                    toast.setTexts(text: "\(response.statusCode): \(response.data)")
                    completionHandler(.failure(ResponseCode.badStatus))
                }
            }
        }
    }
    
    
    // MARK: - Configuration
    
    func fetchVersioning(
        then completionHandler: @escaping VersioningHandler
    ) {
        API.provider.request(.versioning) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                
            case .success(let response):
                if response.response?.statusCode == self.HTTP_OK_CODE {
                    let result = self.parseVersioningResponse(response.data)
                    completionHandler(result)
                } else {
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    // MARK: - Vehicles
    func fetchVehicles(
        then completionHandler: @escaping VehiclesHandler
    ) {
        API.provider.request(.getVehicles) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseVehiclesResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "fetchVehicles") {
                        self.fetchVehicles(then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func fetchUserVehicle(
        then completionHandler: @escaping VehicleHandler
    ) {
        API.provider.request(.getUserVehicle) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                if response.response?.statusCode == self.HTTP_OK_CODE {
                    let result = self.parseVehicleResponse(response.data)
                    completionHandler(result)
                } else {
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func storeUserVehicle(vehicle: Vehicle, then completionHandler: @escaping StoreVehicleHandler) {
        API.provider.request(.storeVehicle(vehicleId: vehicle.vehicleID)) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == self.HTTP_OK_CODE {
                    let result = self.parseStoreVehicleResponse(response.data)
                    completionHandler(result)
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "storeUserVehicle") {
                        self.storeUserVehicle(vehicle: vehicle, then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func deleteUserVehicle(then completionHandler: @escaping SuccessfulHandler) {
        API.provider.request(.deleteVehicle) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300  {
                    completionHandler(.success(true))
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "deleteUserVehicle") {
                        self.deleteUserVehicle(then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    // MARK: - Odometer
    func skipOdometer(then completionHandler: @escaping SuccessfulHandler) {
        API.provider.request(.odometerSkip) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300  {
                    completionHandler(.success(true))
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "skipOdometer") {
                        self.skipOdometer(then: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    func scanOdometer(with image: Data, completionHandler: @escaping ResultHandler) {
        displayLoadingToast()
        API.provider.request(.odometerScan(image: image)) { (result) in
            switch result {
            case .failure(let error):
                self.hideLoadingToast()
                completionHandler(.failure(error))
            case .success(let response):
                self.hideLoadingToast()
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300 {
                    let result = self.parseResultResponse(response.data)
                    completionHandler(result)
                } else {
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func checkOdometer(value: Int, completionHandler: @escaping SuccessfulHandler) {
        API.provider.request(.odometerCheck(value: value)) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300  {
                    completionHandler(.success(true))
                } else {
                    completionHandler(.failure(ResponseCode.badStatus))
                }
            }
        }
    }
    
    func storeOdometer(value: Int, inputType: OdometerStore.InputType, completionHandler: @escaping SuccessfulHandler) {
        API.provider.request(.odometerStore(value: value, inputType: inputType)) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300  {
                    completionHandler(.success(true))
                } else {
                    NetworkErrorHandler.shared.handle(with: statusCode, key: "checkOdometer") {
                        self.checkOdometer(value: value, completionHandler: completionHandler)
                    } catch: {
                        completionHandler(.failure(ResponseCode.decodingWentWrong))
                    }
                }
            }
        }
    }
    
    // MARK: - CDR Methods
    func getCdrs(types: [CdrType]? = nil, query: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, limit: Int = 20, offset: Int = 0, completionHandler: @escaping CdrListHandler) {
        API.provider.request(.cdrUser(types: types, query: query, dateFrom: dateFrom, dateTo: dateTo, limit: limit, offset: offset)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300 {
                    completionHandler(self.parseCdrListResponse(response.data))
                } else {
                    completionHandler(.success(CdrList(cdrs: [], count: 0)))
                }
            }
        }
    }
    
    func getCdr(id: String, completionHandler: @escaping CdrHandler) {
        API.provider.request(.cdrDetails(id: id)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300 {
                    completionHandler(self.parseCdrResponse(response.data))
                } else {
                    completionHandler(.failure(ResponseCode.decodingWentWrong))
                }
            }
        }
    }
    
    func getCdrStats(types: [CdrType], dateFrom: String? = nil, dateTo: String? = nil, completionHandler: @escaping CdrStatsHandler) {
        API.provider.request(.cdrStatistics(types: types, dateFrom: dateFrom, dateTo: dateTo)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300 {
                    completionHandler(self.parseCdrStatsResponse(response.data))
                } else {
                    completionHandler(.success(CdrStats(totalTime: 0, totalEnergy: 0.0)))
                }
            }
        }
    }
    
    func exportCdr(provider: String, language: String, completionHandler: @escaping SuccessfulHandler) {
        API.provider.request(.cdrExport(provider: provider, language: language)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let response):
                let statusCode = response.response?.statusCode ?? 0
                if statusCode >= 200 && statusCode < 300 {
                    completionHandler(.success(true))
                } else {
                    // Custom error
                    completionHandler(.failure(CdrError.exportError))
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func parseClustersResponse(_ data: Data) -> Result<[ClusterModel], Error> {
        do {
            let clusters = try JSONDecoder().decode([ClusterModel].self, from: data)
            return Result.success(clusters)
        } catch {
            return Result.failure(error)
        }
    }
    
    private func parseLocationsResponse(_ data: Data) -> Result<[LocationModel], Error> {
        do {
            let locations = try JSONDecoder().decode([LocationModel].self, from: data)
            return Result.success(locations)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseLocationResponse(_ data: Data) -> Result<LocationModel, Error> {
        do {
            let location = try JSONDecoder().decode(LocationModel.self, from: data)
            return Result.success(location)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseVersioningResponse(_ data: Data) -> Result<VersioningModel, Error> {
        do {
            let versions = try JSONDecoder().decode(VersioningModel.self, from: data)
            return Result.success(versions)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseEvseResponse(_ data: Data) -> Result<Evse, Error> {
        do {
            let evse = try JSONDecoder().decode(Evse.self, from: data)
            return Result.success(evse)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseEvseCheckResponse(_ data: Data) -> Result<EvseCheck, Error> {
        do {
            let evseCheck = try JSONDecoder().decode(EvseCheck.self, from: data)
            return Result.success(evseCheck)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseStatusResponse(_ data: Data) -> Result<StateResponse, Error> {
        do {
            let state = try JSONDecoder().decode(StateResponse.self, from: data)
            return Result.success(state)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseIdpResponse(_ data: Data) -> Result<IdpResponse, Error> {
        do {
            let state = try JSONDecoder().decode(IdpResponse.self, from: data)
            return Result.success(state)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
            
    private func parseLoginData(_ data: Data) -> Result<User, Error> {
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return Result.success(user)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseUserResponse(_ data: Data) -> Result<User, Error> {
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return Result.success(user)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseRemoteResponse(_ data: Data) -> Result<RemoteResponse, Error> {
        let stringResponse = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
        let response = RemoteResponse(id: stringResponse)
        return Result.success(response)
    }
    
    private func parseMarkAsFavoriteResponse(_ data: Data) -> Result<FavoriteModel, Error> {
        do {
            let response = try JSONDecoder().decode(FavoriteModel.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseTokenResponse(_ data: Data) -> Result<Token, Error> {
        do {
            let response = try JSONDecoder().decode(Token.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseVehiclesResponse(_ data: Data) -> Result<[Vehicle], Error> {
        do {
            let response = try JSONDecoder().decode([Vehicle].self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseVehicleResponse(_ data: Data) -> Result<Vehicle, Error> {
        do {
            let response = try JSONDecoder().decode(Vehicle.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseStoreVehicleResponse(_ data: Data) -> Result<Bool, Error> {
        return Result.success(true)
    }
    
    private func parseUserAttributesResponse(_ data: Data) -> Result<UserAttributesModel, Error> {
        do {
            let response = try JSONDecoder().decode(UserAttributesModel.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseResultResponse(_ data: Data) -> Result<ResultResponse, Error> {
        do {
            let response = try JSONDecoder().decode(ResultResponse.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseCdrListResponse(_ data: Data) -> Result<CdrList, Error> {
        do {
            let response = try JSONDecoder().decode(CdrList.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseCdrResponse(_ data: Data) -> Result<Cdr, Error> {
        do {
            let response = try JSONDecoder().decode(Cdr.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    private func parseCdrStatsResponse(_ data: Data) -> Result<CdrStats, Error> {
        do {
            let response = try JSONDecoder().decode(CdrStats.self, from: data)
            return Result.success(response)
        } catch {
            debugPrint(error)
            return Result.failure(error)
        }
    }
    
    
    func displayLoadingToast() {
        ToastDisplayer.shared.display(self.loadingToast)
    }

    func hideLoadingToast() {
        ToastDisplayer.shared.dismiss(self.loadingToast) {
            ToastDisplayer.currentToast = nil
        }
    }
}

// MARK: - Errors
enum CdrError: Error {
    case exportError
}
extension CdrError: LocalizedError{
    var errorDescription : String? {
        switch self {
        case .exportError:
            return NSLocalizedString("Export Error", comment: "Export Error")
        }
    }
}
