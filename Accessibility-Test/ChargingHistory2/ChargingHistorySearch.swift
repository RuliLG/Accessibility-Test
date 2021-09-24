//
//  ChargingHistorySearch.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 14/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct ChargingHistorySearch: View {
    @State var query: String = ""
    @ObservedObject var cdrService = CdrService()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Navbar(title: SchemeHelper.localizedText(forKey: "searchBarBox_search_placeholder"), dismissAction: {
                presentationMode.wrappedValue.dismiss()
            }, titleColor: Color(ColorHelper.darkGreyColor()), right: {

            }, modal: {

            })

            TextFieldWithDebounce(placeholder: SchemeHelper.localizedText(forKey: "charging_history_search_hint"), debouncedText: $query, onDebounce: { text in
                let stripped = text.trimmingCharacters(in: .whitespacesAndNewlines)
                if stripped.isEmpty {
                    cdrService.reset()
                } else {
                    cdrService.search(query: text)
                }
            })
                .padding(.horizontal, 30.0)
                .accessibility(identifier: "ch_search_textfiel_box")
                .accessibility(hidden: false)

            if cdrService.cdrCount == 0 {
                Spacer()
                EmptyState(text: SchemeHelper.localizedText(forKey: "charging_history_empty_search"), imageName: "search")
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: .some(20.0), content: {
                        ForEach(cdrService.cdrs, id: \.uid) { cdr in
                            CdrListItem(cdr: cdr)
                                .accessibility(hidden: true)
                        }
                    })
                        .padding(.horizontal, 10.0)
                        .padding(.vertical, 20.0)
                        .accessibility(hidden: true)
                }
                .accessibility(hidden: true)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ChargingHistorySearch_Previews: PreviewProvider {
    static var previews: some View {
        ChargingHistorySearch()
    }
}
