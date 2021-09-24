//
//  PleaseLogin.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 19/7/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct PleaseLogin: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(SchemeHelper.localizedText(forKey: "charging_history_please_login"))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.white)
                .accessibility(identifier: "please_login_title")
                .accessibility(hidden: false)

            Button(action: {
                print("Login")
            }) {
                Text(SchemeHelper.localizedText(forKey: "detail_price_user_logged_out_login"))
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(maxWidth: .infinity, idealHeight: 58, maxHeight: 58, alignment: .center)
                    .background(Color(ColorHelper.ctaColor()))
                    .cornerRadius(10.0)
                    .padding(.top, 20)
                    .foregroundColor(.white)
                    .font(.system(size: 17.0))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .accessibility(hidden: false)
            .accessibility(identifier: "please_login_button")
            
        }
        .padding(.all, padding)
        .background(Color(ColorHelper.brandColor()))
        .accessibility(hidden: true)
    }
    
    var padding: CGFloat = {
        if iphoneSE() {
            return 10
        } else {
            return 30
        }
    }()
    
}

struct PleaseLogin_Previews: PreviewProvider {
    static var previews: some View {
        PleaseLogin()
    }
}

private func iphoneSE() -> Bool{
    UIScreen.main.bounds.size.width == 320 ? true : false
}
