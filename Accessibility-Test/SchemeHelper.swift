//
//  ColorHelper.swift
//  eChargeApp
//
//  Created by David Amo on 20/04/2020.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation
import UIKit

class SchemeHelper {
    
    // MARK: String helpers
    static func localizedText(forKey key: String) -> String {
        // Used to check for existence of string
        let notFoundString = "-----NOTFOUND-----"
        
        // 1. Try to find string in Scheme.strings file
        let schemedText = Bundle.main.localizedString(forKey: key, value: notFoundString, table: "Scheme")
        if (schemedText != notFoundString) {
            return schemedText
        }
        
        // 2. Try to find string in Localizable.strings file
        let localizedText = Bundle.main.localizedString(forKey: key, value: notFoundString, table: nil)
        if (localizedText != notFoundString) {
            return localizedText
        }
        
        // 3. If both failed, return key as string
        return key
    }
    
    
    // MARK: Other helpers
    
    static func appIcon() -> UIImage? {
        return isAralScheme ? UIImage(named: "IconAral") : UIImage(named: "IconBp")
    }
    
    static func chevronIcon() -> UIImage? {
        return isAralScheme ? UIImage(named: "ic_chevron_right_aral") : UIImage(named: "ic_chevron_right_bp")
    }
}
