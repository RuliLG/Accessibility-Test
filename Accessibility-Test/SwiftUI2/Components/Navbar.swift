//
//  Navbar.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 19/7/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct Navbar<Content, ModalContent>: View where Content: View, ModalContent: View {
    var title: String
    var dismissAction: (() -> Void)
    var titleColor: Color
    var right: () -> Content?
    var modal: () -> ModalContent?
    var hasModal = false
    
    @State private var isDisplayingModal = false
    
    init(
        title: String,
        dismissAction: @escaping (() -> Void) = { },
        titleColor: Color = Color(ColorHelper.darkGreyColor()),
        @ViewBuilder right: @escaping () -> Content? = { nil },
        @ViewBuilder modal: @escaping () -> ModalContent? = { nil },
        hasModal: Bool = false
    ) {
        self.title = title
        self.dismissAction = dismissAction
        self.titleColor = titleColor
        self.right = right
        self.modal = modal
        self.hasModal = hasModal
    }

    var body: some View {
        ZStack {
            HStack {
                Button(action: dismissAction) {
                    Image("ic_back_btn")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 52, height: 52, alignment: .center)
                }
                .accessibility(hidden: false)
                .accessibility(identifier: "ch_back_btn")
                Spacer()
            }
                .accessibility(hidden: true)
            HStack(alignment: .center, spacing: 5.0, content: {
                Spacer()
                Text(title)
                    .foregroundColor(titleColor)
                    .accessibility(identifier: "ch_title")
                    .accessibility(hidden: false)
                if hasModal {
                    Button(action: {
                        isDisplayingModal.toggle()
                    }, label: {
                        Image("ic_question_charging_history")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 23.1, height: 23.1)
                        
                    })
                    .compatibleFullScreen(isPresented: $isDisplayingModal, content: modal)
                    .accessibility(identifier: "ch_question_charging_history")
                    .accessibility(hidden: false)
                    
                }
                Spacer()
            })
            .accessibility(hidden: true)
            HStack {
                Spacer()
                right()
            }
            .accessibility(hidden: true)
        }
        .padding(.horizontal, 20)
    }
}
