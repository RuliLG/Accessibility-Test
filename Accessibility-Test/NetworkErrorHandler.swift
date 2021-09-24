//
//  NetworkErrorHandler.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 1/12/20.
//  Copyright © 2020 Trafineo. All rights reserved.
//

import Foundation

class NetworkErrorHandler {
    static var shared = {
        return NetworkErrorHandler()
    }()
    
    private var requests: [String: Int] = [:]
    
    func handle(with code: Int, key: String, then successHandler: @escaping () -> (), catch errorHandler: @escaping () -> ()) {
        requests[key] = (requests[key] ?? 0) + 1
        if code == 401 {
            if requests[key]! <= 1 {
                AuthManager.refreshToken { (result) in
                    switch result {
                    case .failure(let error):
                        if let response = error as? ResponseCode, response == ResponseCode.unauthorized {
                            // Another 401 -> Redirect to login with a toast message
                            AppCoordinator.shared?.navigateToMain()
                            if let vc = getCurrentViewController() {
                                let login = LoginController()
                                login.modalPresentationStyle = .fullScreen
                                vc.present(login, animated: true, completion: nil)
                                
                                self.display(for: 401, name: "status_401_token_expired")
                            }
                        } else {
                            errorHandler()
                        }
                    case .success:
                        successHandler()
                    }
                }
            } else {
                requests[key] = 0
                errorHandler()
                display(for: code, name: nil)
            }
        } else {
            requests[key] = 0
            display(for: code, name: nil)
            errorHandler()
        }
    }
    
    func display(for code: Int, name: String?) {
        var name = name
        if name == nil {
            switch code {
            case 400:
                name = "common_status_400"
            case 401:
                name = "common_status_401"
            case 404:
                name = "common_status_404"
            case 500:
                name = "common_status_500"
            case 1000, 1003, 1004, 409:
                name = "error_card_already_assigned"
            case 1001:
                name = "error_card_not_found"
            case 1002:
                name = "error_card_not_activated"
            default:
                break
            }
        }
        
        guard let key = name else {
            return
        }

        let toast = ErrorToastView.instanceFromNib()
        toast.setTexts(title: SchemeHelper.localizedText(forKey: "common_error"), description: SchemeHelper.localizedText(forKey: key))
        ToastDisplayer.shared.display(toast, duration: 0.3, offset: 0.0, location: .Top, hideAfter: 5.0)
    }
}
