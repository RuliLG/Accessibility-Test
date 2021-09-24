//
//  MainViewModel.swift
//  eChargeApp
//
//  Created by Gihad Chbib on 03.05.20.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import MapKit


struct MainViewModel {
    static private let nullIsland = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    static var searchLocation: CLLocationCoordinate2D?
    static var currentCenterMapLocation: CLLocationCoordinate2D = nullIsland
    static var cellMapLocation: CLLocationCoordinate2D = nullIsland
    static var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.0932014, longitude: 4.3096556)
    
    static var nearbyLocations = [LocationModel]()

    static var isClusterSelected = false
    static var areMetadataClusterDisplayed = true
    
    static var user: User? = nil
    static var userAttributes: UserAttributesModel? = nil
    static var favorites: [LocationModel] = []
    
    static func hasFavorite(location: LocationModel) -> Bool {
        guard let _ = Self.user else {
            return false
        }

        for favorite in favorites {
            if favorite.id == location.id {
                return true
            }
        }
        
        return false
    }
    
    static func fetchFavorites(then completionHandler: ( (_ fetched: Bool) -> ())?) {
        guard let _ = Self.user else {
            completionHandler?(false)
            return
        }

        Self.favorites = []
        completionHandler?(true)
    }
}
