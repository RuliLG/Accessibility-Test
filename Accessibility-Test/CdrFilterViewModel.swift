//
//  CdrFilterViewModel.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 14/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI
import Combine

class CdrFilterViewModel: ObservableObject {
    @Published var showOnly: [CdrType] = []
    @Published var timeframe: ChargingHistoryTimeframe = .all
    @Published var isFiltering: Bool = false
    
    @Published var editableShowOnly: [CdrType] = []
    @Published var editableTimeframe: ChargingHistoryTimeframe = .all
    
    init() {
        refresh()
    }
    
    func save() {
        refresh()
    }
    
    func saveWithoutModifyingFilterFlag() {
        refresh()
    }
    
    func refresh() {
        editableTimeframe = timeframe
        editableShowOnly = showOnly
    }
    
    func reset() {
        editableTimeframe = .all
        editableShowOnly = [.Public]
    }
    
    func numberOfFilters() -> Int {
        if showOnly.count == 1 && timeframe == .all {
            return 0
        }

        var n = 0
        if timeframe != .all {
            n += 1
        }
        
        n += showOnly.count
        
        return n
    }
    
    func hasFilters() -> Bool {
        return numberOfFilters() > 0
    }
    
    func isDefaultFilter() -> Bool {
        return showOnly.count == 1 && showOnly[0] == .Public && timeframe == .all
    }
    
    private func toCdrTypes(_ text: String) -> [CdrType] {
        let texts = text.split(separator: ",").filter { !$0.isEmpty }

        return texts.compactMap { cdrType(from: String($0)) }.uniqued()
    }
    
    private func toTimeframe(_ text: String) -> ChargingHistoryTimeframe {
        switch text {
        case "lastWeek":
            return .lastWeek
        case "lastTwoMonths":
            return .lastTwoMonths
        case "lastMonth":
            return .lastMonth
        default:
            return .all
        }
    }
}

