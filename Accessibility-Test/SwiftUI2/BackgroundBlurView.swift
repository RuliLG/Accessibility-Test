//
//  BackgroundBlurView.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 30/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
