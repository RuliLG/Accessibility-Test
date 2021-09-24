//
//  ChargingHistoryLegendModal.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 13/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct ChargingHistoryLegendModal: View {
    
    var body: some View {
        GrayModal(title: SchemeHelper.localizedText(forKey: "charging_history_legend_title"), message: SchemeHelper.localizedText(forKey: "charging_history_legend_message"), content: {
            VStack(alignment: .leading, spacing: 10.0, content: {
                row(title: SchemeHelper.localizedText(forKey: "charging_history_legend_energy"), image: "Illu_totalenergy")
                    .fixedSize(horizontal: true, vertical: true)
                row(title: SchemeHelper.localizedText(forKey: "charging_history_legend_time"), image: "Illu_totaltime")
                    .fixedSize(horizontal: true, vertical: true)
                Spacer()
                    .frame(minHeight: 30.0, idealHeight: 80.0, maxHeight: 80.0)
            })
            .accessibility(hidden: true)
        }, padding: 20.0)
    }
    
    private func row(title: String, image: String) -> some View {
        return VStack(alignment: .leading, spacing: nil) {
            HStack(alignment: .top, spacing: 10.0, content: {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40.0, alignment: .center)
                    .accessibility(identifier: "chlm_\(image.description)")
                    .accessibility(hidden: false)
                Text(title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 0, idealWidth: 10, maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibility(identifier: "chlm_\(title.description)")
                    .accessibility(hidden: false)
            })
            .accessibility(hidden: true)
        }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 10.0)
            .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity)
            .background(Color.white)
            .accessibility(hidden: true)
    }
}
