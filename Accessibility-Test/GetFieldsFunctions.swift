//
//  GetFieldsFunctions.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 14/12/20.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation

/**
 * Returns the 'locationFields' query parameters for nearby stations on the list.
 */
func getLocationFieldsList() -> String {
    return [
        "id",
        "latitude",
        "longitude",
        "street",
        "city",
        "country",
        "postal_code",
        "is_open_24_7",
        "charging_when_closed",
        "userDistance"
    ].joined(separator: ",")
}
/**
 * Returns the 'evseFields' query parameters for nearby stations on the list.
 */
func getEvseFieldsList() -> String {
    return [
        "id",
        "evse_id",
        "status",
        "auth_modes"
    ].joined(separator: ",")
}
/**
 * Returns the 'connectorFields' query parameters for nearby stations on the list.
 */
func getConnectorFieldsList() -> String {
    return [
        "id",
        "plug_type",
        "power_type",
        "power",
        "amperage",
        "voltage"
    ].joined(separator: ",")
}
/**
 * Returns the 'locationFields' query parameters for nearby stations on the map.
 */
func getLocationFieldsMap() -> String {
    return [
        "id",
        "latitude",
        "longitude"
    ].joined(separator: ",")
}
/**
 * Returns the 'evseFields' query parameters for nearby stations on the map.
 */
func getEvseFieldsMap() -> String {
    return [
        "id",
        "evse_id",
        "status"
    ].joined(separator: ",")
}
/**
 * Returns the 'connectorFields' query parameters for nearby stations on the map.
 */
func getConnectorFieldsMap() ->  String {
    return "id"
}
