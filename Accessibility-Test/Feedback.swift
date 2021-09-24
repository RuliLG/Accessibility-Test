//
//  Feedback.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 1/3/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import UIKit

class Feedback {
    static func selectionChanged() {
        success()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
