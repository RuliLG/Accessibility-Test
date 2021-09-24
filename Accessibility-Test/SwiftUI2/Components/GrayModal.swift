//
//  GrayModal.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 13/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct GrayModal<Content: View>: View {
    var title: String?
    var message: String?
    var content: () -> Content
    var padding: CGFloat = 20.0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            VStack {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image("ic_close-light")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 42, height: 42, alignment: .center)
                            }
                            .accessibility(hidden: false)
                            .accessibility(identifier: "chlm_dismiss")
                        }
                            .accessibility(hidden: true)
                        if let title = title {
                            Text(title)
                                .font(.system(size: 17.0))
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .accessibility(identifier: "chlm_title")
                                .accessibility(hidden: false)
                        }
                        
                        if let message = message {
                            Text(message)
                                .font(.system(size: 17.0))
                                .lineLimit(0)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 40.0)
                                .accessibility(hidden: false)
                                .accessibility(identifier: "chlm_description")
                        }
                    }
                        .padding(padding)
                        .accessibility(hidden: true)

                    content()
                }
                    .background(Color(ColorHelper.paleGreyColor2()))
                    .padding(20.0)
                    .foregroundColor(Color(ColorHelper.darkGreyColor()))
                
                Spacer()
            }
        }
    }
}

struct GrayModal_Previews: PreviewProvider {
    @State var showModal = true

    static var previews: some View {
        GrayModal(title: "Legend", message: "My first modal message") {
            Text("My first modal")
        }
    }
}
