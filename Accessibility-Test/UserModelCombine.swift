//
//  UserModelCombine.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 12/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI
import Combine

class UserModelCombine: ObservableObject {
    @Published var user: User? = nil
    
    static let shared = UserModelCombine()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginInfoChanged), name: .didUserLoginChangedNotificationData, object: nil)
        loginInfoChanged()
    }
    
    @objc func loginInfoChanged() {
        user = MainViewModel.user
    }
}
