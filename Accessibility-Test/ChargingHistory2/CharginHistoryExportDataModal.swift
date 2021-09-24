//
//  CharginHistoryExportDataModal.swift
//  eChargeApp
//
//  Created by Pedro Sánchez on 27/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct CharginHistoryExportDataModal : View {
    @State private var title = SchemeHelper.localizedText(forKey: "charging_history_export_start_title")
    @State private var description = SchemeHelper.localizedText(forKey: "charging_history_export_start_description")
    @State private var buttonText = SchemeHelper.localizedText(forKey: "charging_history_export_start_button_text")

    private var paddingTopToCard: CGFloat {
        UIScreen.main.bounds.size.height == 896 ? 180 : 115
    }
    
    let close: () -> Void
    
    @State private var sentExportData = false
    @State private var progressView = false
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack {
            ZStack {
                // Modal card
                VStack {
                    // Elements
                    VStack {
                        // Navbar
                        HStack {
                            Spacer()
                            Button(action: {
                                close()
                            }) {
                                Image("ic_close-light")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 42, height: 42, alignment: .center)
                            }
                        }
                        .padding([.top, .trailing], 20)
                        // Title
                        Text($title.wrappedValue)
                            .font(.system(size: 17.0))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding([.bottom,.leading, .trailing, .top], 20)
                        
                        // Description
                        Text($description.wrappedValue)
                            .font(.system(size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding(.all,20)
                        
                        // Button
                        Button(action: {
                            if sentExportData {
                                close()
                            } else {
                                progressView = true
                                self.$progressView.wrappedValue = false
                                self.title = SchemeHelper.localizedText(forKey: "charging_history_export_sent_title")
                                self.description = """
                                                    \(SchemeHelper.localizedText(forKey: "charging_history_export_sent_description_paragraph_one"))
                                                    \(SchemeHelper.localizedText(forKey: "charging_history_export_sent_description_paragraph_two"))
                                                    """
                                self.buttonText = SchemeHelper.localizedText(forKey: "common_close")
                                sentExportData = true
                            }
                        }) {
                            Text($buttonText.wrappedValue)
                                .padding()
                                .font(.system(size: 17.0))
                                .frame(width: UIScreen.main.bounds.size.width - 80, height: 55, alignment: .center)
                                .foregroundColor(.white)
                            
                        }
                        .foregroundColor(.white)
                        .background(Color(ColorHelper.ctaColor()))
                        .cornerRadius(5)
                        .padding(.all, 20)
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    .visibility(hidden: $progressView.wrappedValue)
                }
                .background(Color(ColorHelper.paleGreyColor2()))
                .foregroundColor(Color(ColorHelper.darkGreyColor()))
                .padding([.leading, .trailing],20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, paddingTopToCard)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.7))
            .edgesIgnoringSafeArea(.all)
            //            .transition(.move(edge: .bottom))
            .alert(isPresented: $showErrorAlert, content: {
                Alert(title: Text(SchemeHelper.localizedText(forKey: "charging_history_export_error_nav_bar_title")),
                      message: Text(SchemeHelper.localizedText(forKey: "charging_history_export_error_description")),
                      dismissButton: .default(Text(SchemeHelper.localizedText(forKey: "common_ok")),
                                              action: {close()} ))
            })
            
            if (progressView) {
                ActivityIndicator()
                    .padding(.top, paddingTopToCard)
            }
        }
        .transition(.move(edge: .bottom)) //Check this transition. Biding?
    }
}

