//
//  CdrService.swift
//  eChargeApp BP
//
//  Created by Raúl López Gutiérrez on 5/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import Combine
import SwiftUI

class CdrService: ObservableObject {
    @Published var cdrs: [Cdr] = []
    @Published var cdrCount = 0
    @Published var totalTime = 0
    @Published var totalEnergy = 0.0
    @Published var totalPages = 0
    @Published var currentPage = 1
    private let limit = 20
    private var types: [CdrType]
    
    
    init() {
        self.types = []
    }

    init(with types: [CdrType]) {
        self.types = types
        fetchCdrs(of: types, shouldReset: true)
        
        NotificationCenter.default.addObserver(forName: .didUserLoginChangedNotificationData, object: nil, queue: nil) { _ in
            self.fetchCdrs(of: self.types, shouldReset: true)
        }
    }
    
    func search(query: String) {
//        guard let _ = MainViewModel.user else {
//            return
//        }
        
        reset()

        let cdrList: CdrList = CdrList(cdrs: ALL_CDRS, count: ALL_CDRS.count)
        self.cdrs = cdrList.cdrs
        self.cdrCount = cdrList.count
    }
    
    func fetchCdrs(of types: [CdrType], shouldReset: Bool) {
        self.types = types
//        guard let _ = MainViewModel.user else {
//            return
//        }

        if shouldReset {
            reset()
        }
        
        stats(of: types)
        
        let cdrList: CdrList = CdrList(cdrs: ALL_CDRS, count: ALL_CDRS.count)
        self.currentPage = self.cdrCount == 0 ? 1 : self.currentPage
        self.cdrs = cdrList.cdrs
        self.cdrCount = cdrList.count
        self.totalPages = Int(ceil(Double(cdrList.count) / Double(self.limit)))
        self.currentPage = self.cdrCount == 0 ? 0 : self.currentPage
    }
    
    func goToPage(_ page: Int) {
        if page <= totalPages && page > 0 {
            currentPage = page
            fetchCdrs(of: types, shouldReset: false)
        }
    }
    
    func stats(of types: [CdrType]) {
        self.types = types
//        guard let _ = MainViewModel.user else {
//            return
//        }

        self.totalTime = 1000
        self.totalEnergy = 500
    }
    
    func reset() {
        cdrs = []
        cdrCount = 0
    }
    
    
    private func getDateFrom() -> String? {
        return nil
    }
}
