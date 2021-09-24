//
//  PlugHelper.swift
//  eChargeApp
//
//  Created by Merino Fajardo García on 07/10/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import UIKit

/// Indicates the plugs types by string.
enum PlugType: String {
    case type1
    case type2
    case type3
    case typeF
    case chademo
    case ccs
    case none
}

/// Returns a Set of plugs types (make them unique and not repeted).
func getSetOfPlugTypes(from location: LocationModel) -> Set<PlugType> {
    let connectors = location.evses.flatMap { $0.connectors ?? [] }
    let allPlugNames = connectors.compactMap { $0.plugType }
    let allPlugTypes = allPlugNames.map { getPlugType(from: $0) }

    let plugsTypes = Set(allPlugTypes)
    
    return plugsTypes
}

/// Returns the image of a given plug.
func getPlugImage(for plug: PlugType) -> UIImage {
    switch plug {
    case .type1:
        return UIImage(named: "Type 1 Connector Cable Attached")!.withRenderingMode(.alwaysTemplate)
    case .type2:
        return UIImage(named: "Type 2")!.withRenderingMode(.alwaysTemplate)
    case .type3:
        return UIImage(named: "Type 3 Outlet")!.withRenderingMode(.alwaysTemplate)
    case .typeF:
        return UIImage(named: "OtherConnector")!.withRenderingMode(.alwaysTemplate)
    case .chademo:
        return UIImage(named: "CHAdeMO")!.withRenderingMode(.alwaysTemplate)
    case .ccs:
        return UIImage(named: "CSS Combo 2")!.withRenderingMode(.alwaysTemplate)
    default:
        return UIImage(named: "Unknown")!.withRenderingMode(.alwaysTemplate)
    }
}

func getPlugImage(from name: String) -> UIImage {
    let plug = getPlugType(from: name)
    return getPlugImage(for: plug)
}

func getPlugLocalizedName(for name: String) -> String {
    let plug = getPlugType(from: name)
    return getPlugLocalizedName(from: plug)
}

func getPlugLocalizedName(from plug: PlugType) -> String {
    switch plug {
    case .type1:
        return SchemeHelper.localizedText(forKey: "filter_connector_t1s")
    case .type2:
        return SchemeHelper.localizedText(forKey: "filter_connector_t2s")
    case .type3:
        return SchemeHelper.localizedText(forKey: "filter_connector_t3s")
    case .typeF:
        return SchemeHelper.localizedText(forKey: "filter_connector_other")
    case .chademo:
        return SchemeHelper.localizedText(forKey: "filter_connector_cha")
    case .ccs:
        return SchemeHelper.localizedText(forKey: "filter_connector_ccs")
    default:
        return SchemeHelper.localizedText(forKey: "detail_unknown")
    }
}


typealias ConnectorPlugAndPower = (plug: PlugType, power: Double, status: String?)
/// Returns a list of connectors that is first sorted by availability and then by power
func extractConnectorPlugAndPower(from location: LocationModel) -> [ConnectorPlugAndPower] {
    var imagesAndPowersAvailable: [ConnectorPlugAndPower] = []
    var imagesAndPowersOccupied: [ConnectorPlugAndPower] = []
    for evse in location.evses {
        if let cons = evse.connectors {
            for con in cons {
                let power = con.power ?? 0
                let roundPower = Double(round(10*power)/10)
                let plug = getPlugType(from: con.plugType ?? "-")
                if evse.status == "AVAILABLE" {
                    imagesAndPowersAvailable.append((plug, roundPower, evse.status))
                }
                else {
                    imagesAndPowersOccupied.append((plug, roundPower, evse.status))
                }
            }
        }
    }
    imagesAndPowersAvailable = imagesAndPowersAvailable.sorted(by: {$0.power > $1.power})
    imagesAndPowersOccupied = imagesAndPowersOccupied.sorted(by: {$0.power > $1.power})
    return imagesAndPowersAvailable+imagesAndPowersOccupied
}

func getPlugType(from name: String) -> PlugType {
    let name = name.lowercased()
    
    // Backend codes
    if name == "ttr" { return .none }
    else if name == "tt2" { return .none }
    else if name == "t1s" { return .type1 }
    else if name == "t2s" { return .type2 }
    else if name == "cha" { return .chademo }
    else if name == "supercharger" { return .type2 }
    
    // CSS
    if name.contains("ccs") { return .ccs }
    else if name.contains("combo") { return .ccs }
    // Type 1
    else if name.contains("type1") { return .type1 }
    else if name.contains("type 1") { return .type1 }
    else if name.contains("t1") { return .type1 }
    else if name.contains("j1772") { return .type1 }
    else if name.contains("avcon") { return .type1}
    // Type 2
    else if name.contains("type2") { return .type2 }
    else if name.contains("type 2") { return .type2 }
    else if name.contains("t2") { return .type2 }
    else if name.contains("rapid-ac") { return .type2 }
    else if name.contains("iec_62196_t2") { return .type2 }
    // Type 3
    else if name.contains("type3") { return .type3 }
    else if name.contains("type 3") { return .type3 }
    else if name.contains("t3") { return .type3 }
    // Type F
    else if name.contains("typef") { return .typeF }
    else if name.contains("type f") { return .typeF }
    else if name.contains("3 pin") { return .typeF }
    else if name.contains("type e") { return .typeF }
    else if name.contains("domestic") { return .typeF }
    // CHAdeMO
    else if name.contains("chademo") { return .chademo }
    // NONE
    else { return .none }
}

func transformPlugsTypeToAPIString(_ plugs: [PlugType]) -> String? {
    if plugs.isEmpty { return nil }
    
    var apiPlugsString: [String] = []
    
    plugs.forEach { plug in
        switch plug {
        case .type1:
            apiPlugsString.append("T1S")
        case .type2:
            apiPlugsString.append("T2S")
        case .type3:
            apiPlugsString.append("T3S")
        case .typeF:
            apiPlugsString.append("SHH")
        case .chademo:
            apiPlugsString.append("CHA")
        case .ccs:
            apiPlugsString.append("CCS")
        case .none:
            break
        }
    }
    
    return apiPlugsString.joined(separator: ",")
}
