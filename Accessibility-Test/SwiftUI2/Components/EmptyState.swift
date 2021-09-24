//
//  EmptyState.swift
//  eChargeApp BP
//
//  Created by Raúl López Gutiérrez on 5/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct EmptyState: View {
    var text: String
    var imageName: String?

    var body: some View {
        VStack(alignment: .center, spacing: 30.0, content: {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, idealWidth: 64, maxWidth: .infinity, minHeight: 0, idealHeight: 50, maxHeight: 50, alignment: .center)
                    .foregroundColor(Color(ColorHelper.darkGreyColor()))
                    .accessibility(hidden: false)
                    .accessibility(identifier: "emptystate_\(imageName.description)")
            }
            
            Text(text)
                .foregroundColor(Color(ColorHelper.darkGreyColor()))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .font(.system(size: 17.0))
                .lineLimit(.none)
                .accessibility(hidden: false)
                .accessibility(identifier: "emptystate_\(text.description)")
        })
        .accessibility(hidden: true)
        .padding(.horizontal, 30.0)
    }
}

struct EmptyState_Previews: PreviewProvider {
    static var previews: some View {
        EmptyState(text: "You have not yet started any charging session", imageName: "icon_chargehistory")
    }
}
