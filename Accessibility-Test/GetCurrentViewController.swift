//
//  GetCurrentViewController.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 2/12/20.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import UIKit

func getCurrentViewController() -> UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        return topController
    }

    return nil
}
