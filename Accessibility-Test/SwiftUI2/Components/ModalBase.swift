//
//  ModalBase.swift
//  eChargeApp
//
//  Created by Pedro Sánchez on 27/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct ModalBase<Content: View>: View {
    
    @Binding var showModal: Bool
    let content: Content
    
    init(@ViewBuilder content: () -> Content, showModal: Binding<Bool>) {
        self.content = content()
        self._showModal = showModal
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    if showModal {
                        self.content
                    }
                }
            }
        }
//        .transition(.slide)
//        .background(Color.white)
        .offset(x: 0, y: showModal ? 0 : UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0 )
    }
}
