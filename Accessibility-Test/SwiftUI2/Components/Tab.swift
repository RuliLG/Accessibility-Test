//
//  Tab.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 4/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct TabData {
    var id: String
    var label: String
    var image: UIImage?
}

struct Tab: View {
    var tab: TabData
    var background: UIColor
    var selectedBackground: UIColor
    var foregroundColor = ColorHelper.darkGreyColor()
    var selectedForegroundColor = ColorHelper.whiteColor()
    var isSelected = false
    var onTap: ((_ id: String) -> ())

    var body: some View {
        HStack(alignment: .center, spacing: 10.0, content: {
            if let image = tab.image {
                Image(uiImage: image)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(isSelected ? selectedForegroundColor : foregroundColor))
                    .frame(width: 18.0, height: 18.0, alignment: .center)
                    .accessibility(hidden: false)
                    .accessibility(identifier: "tab_image_\(tab.id)")
            }
            Text(tab.label)
                .foregroundColor(Color(isSelected ? selectedForegroundColor : foregroundColor))
                .font(.system(size: 12.0))
                .fontWeight(isSelected ? .bold : .regular)
                .accessibility(hidden: false)
                .accessibility(identifier: "tab_text_\(tab.id)")
        })
        .frame(minWidth: 20.0, idealWidth: 100, maxWidth: .infinity, minHeight: 32.0, idealHeight: 32.0, maxHeight: 32.0, alignment: .center)
        .background(Color(isSelected ? selectedBackground : background))
        .cornerRadius(4.0)
        .onTapGesture {
            onTap(tab.id)
        }
        .accessibility(hidden: true)
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab(tab: TabData(id: "test", label: "Test", image: nil), background: ColorHelper.paleGreyColor1(), selectedBackground: ColorHelper.availableColor(),
            onTap: { _ in })
        Tab(tab: TabData(id: "test", label: "Charging History", image: UIImage(named: "icon_chargehistory")), background: ColorHelper.paleGreyColor1(), selectedBackground: ColorHelper.availableColor(), isSelected: true, onTap: { _ in })
    }
}
