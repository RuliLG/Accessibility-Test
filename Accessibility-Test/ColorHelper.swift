//
//  ColorHelper.swift
//  eChargeApp
//
//  Created by Merino Fajardo García on 23/7/20.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import UIKit

struct ColorHelper {
    
    // MARK: Colors
    
    static func ctaColor() -> UIColor {
        return isAralScheme ? UIColor(named: "ARAL_ctaColor")! : UIColor(named: "BP_ctaColor")!
    }
    
    static func brandColor() -> UIColor {
        return isAralScheme ? UIColor(named: "ARAL_brandColor")! : UIColor(named: "BP_brandColor")!
    }
    
    static func varianceColor1() -> UIColor {
        return isAralScheme ? UIColor(named: "ARAL_varianceColor1")! : UIColor(named: "BP_varianceColor1")!
    }
    
    static func varianceColor2() -> UIColor {
        return isAralScheme ? UIColor(named: "ARAL_varianceColor2")! : UIColor(named: "BP_varianceColor2")!
    }
    
    static func varianceColor3() -> UIColor {
        return isAralScheme ? UIColor(named: "ARAL_varianceColor3")! : UIColor(named: "BP_varianceColor3")!
    }
    
    static func varianceColor4() -> UIColor {
        return isAralScheme ? UIColor(named: "ARAL_varianceColor4")! : UIColor(named: "BP_varianceColor4")!
    }
    
    static func darkGreyColor() -> UIColor {
        return UIColor(named: "COMMON_darkGreyColor")!
    }
    
    static func greyColor() -> UIColor {
        return UIColor(named: "COMMON_greyColor")!
    }
    
    static func paleGreyColor1() -> UIColor {
        return UIColor(named: "COMMON_paleGreyColor1")!
    }
    
    static func paleGreyColor2() -> UIColor {
        return UIColor(named: "COMMON_paleGreyColor2")!
    }
    
    static func availableColor() -> UIColor {
        return UIColor(named: "COMMON_availableColor")!
    }
    
    static func darkAvailableColor() -> UIColor {
        return UIColor(named: "COMMON_darkAvailableColor")!
    }
    
    static func whiteColor() -> UIColor {
        return UIColor(named: "COMMON_whiteColor")!
    }
    
    static func redColor() -> UIColor {
        return UIColor(named: "COMMON_redColor")!
    }
    
    static func redColorDarkScheme() -> UIColor {
        return UIColor(named: "COMMON_redColorDark")!
    }
    
    static func mediumStrengthColor() -> UIColor {
        return UIColor(named: "COMMON_mediumStrengthColor")!
    }
    
    static func startGradientColor() -> UIColor {
        return isAralScheme ? UIColor(red:0.17, green:0.62, blue:0.84, alpha:1.00) : UIColor(red:0.32, green:0.71, blue:0.00, alpha:1.00)
    }
    
    static func endGradientColor() -> UIColor {
        return isAralScheme ? UIColor(red:0.00, green:0.28, blue:0.51, alpha:1.00) : UIColor(red:0.42, green:0.74, blue:0.00, alpha:1.00)
    }
    
    // MARK: Gradients
    
    enum GradientColorDirection {
        case vertical
        case horizontal
    }
    
    static func generateGradientFromColors(
        _ colors: [UIColor],
        bounds: CGRect,
        direction: GradientColorDirection) -> UIColor {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        if case .horizontal = direction {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        }
        
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        
        UIGraphicsEndImageContext()
        return UIColor(patternImage: gradientImage!)
    }
    
    static func generateGradient(
        bounds: CGRect,
        direction: GradientColorDirection = .horizontal) -> UIColor
    {
        let defaultColors = [ColorHelper.startGradientColor(), ColorHelper.endGradientColor()]
        
        return ColorHelper.generateGradientFromColors(
            defaultColors,
            bounds: bounds,
            direction: direction)
    }
}
