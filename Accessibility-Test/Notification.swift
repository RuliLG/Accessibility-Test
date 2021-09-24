//
//  Notification.swift
//  eChargeApp
//
//  Created by Hannes on 23.11.18.
//  Copyright © 2018 Trafineo. All rights reserved.
//

import NotificationCenter

extension Notification.Name {
    // MARK: Notifications for the AppCoordinator
    static let navigateToMain = Notification.Name("navigateToMain")

    static let favoriteCelldidReceiveNotificationData = Notification.Name("favoriteCelldidReceiveNotificationData")

    static let filterDidChangeNotificationData = Notification.Name("filterDidChangeNotificationData")

    static let remoteViewDidReceiveNotificationData = Notification.Name("remoteViewDidReceiveNotificationData")
    
    static let didUserLoginChangedNotificationData = Notification.Name("didUserLoginChangedNotificationData")
    
    static let didUsernameChange = Notification.Name("didUserChangeHisName")
    
    static let searchButtonTapped = Notification.Name("searchButtonTapped")

    // MARK: Notifications for the map
    static let didReceiveLocationNotificationData = Notification.Name("didReceiveLocationNotificationData")

    static let didReceiveClustersNotificationData = Notification.Name("didReceiveClustersNotificationData")

    static let didReceiveSearchNotificationData = Notification.Name("didReceiveSearchNotificationData")

    static let didClickOnLocationButton = Notification.Name("didClickOnLocationButton")
    
    static let didUpdateChargepoints = Notification.Name("didUpdateChargepoints")
    
    static let moveMapToLocation = Notification.Name("moveMapToLocation")
    
    static let userDidChangeLocation = Notification.Name("userDidChangeLocation")
    
    // MARK: Notifications for the MainController
    static let showDetailsOverlay = Notification.Name("showDetailsOverlay")
    
    static let goToMap = Notification.Name("goToMap")
    
    static let updateMapView = Notification.Name("updateMapView")
    
    static let updateRemoteChargingStatus = Notification.Name("updateRemoteChargingStatus")
    
    // MARK: Notification for the change of distance preference
    static let didChangeDistancePreference = Notification.Name("didChangeDistancePreference")
    
    // MARK: Push notifications
    static let didOpenPushNotification = Notification.Name("didOpenPushNotification")
}
