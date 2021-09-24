//
//  RoundedImageButton.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 19/7/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct RoundedImageButton: View {
    var imageName: String
    var action: (() -> Void)

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .renderingMode(.original)
                .resizable()
                .frame(width: 24, height: 24, alignment: .center)
                .aspectRatio(contentMode: .fit)
        }
        .padding(10)
        .frame(width: 40, height: 40, alignment: .center)
        .background(Color.white)
        .cornerRadius(999)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 0)
    }
}

struct RoundedImageButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedImageButton(imageName: "search") {
            print("click")
        }
    }
}
