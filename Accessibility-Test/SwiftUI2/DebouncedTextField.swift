//
//  DebouncedTextField.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 14/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI
import Combine

struct TextFieldWithDebounce : View {
    var placeholder: String
    @Binding var debouncedText : String
    var onDebounce: (_ text: String) -> ()
    var debounceMs: Int = 500
    @State var text = ""
    @State private var prevTimestamp: Int64 = Date().millisecondsSince1970
    @State private var timer: Timer? = nil
    @State private var prevText: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                TextField(placeholder, text: $text)
                    .frame(height: 50)
                    .padding(.leading, 10.0)
                    .padding(.trailing, 50.0)
                    .background(Color.white)
                    .cornerRadius(9999)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 0)
                HStack {
                    Spacer()
                    Button(action: {
                        onDebounce("")
                        prevTimestamp = Date().millisecondsSince1970
                    }) {
                        Image("close")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                    .accessibility(hidden: false)
                    .accessibility(identifier: "textfield_clear_button")
                    Spacer().frame(width: 10.0)
                }
                .accessibility(hidden: true)
            }
        }
        .onReceive(text.publisher) { _ in
            let now = Date().millisecondsSince1970
            let remaining = Int64(debounceMs) - (now - prevTimestamp)
            if remaining <= 0 {
                notify()
            } else {
                timer?.invalidate()
                Timer.scheduledTimer(withTimeInterval: Double(remaining) / 1000, repeats: false) { _ in
                    notify()
                }
            }
        }
    }
    
    private func notify() {
        if prevText != text {
            onDebounce(text)
            prevText = text
        }

        prevTimestamp = Date().millisecondsSince1970
    }
}
