//
//  Tabs.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 19/7/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct Tabs: View {
    var tabs: [TabData]
    var background: UIColor = ColorHelper.paleGreyColor1()
    var selectedBackground: UIColor = ColorHelper.availableColor()
    var color: UIColor = ColorHelper.darkGreyColor()
    var selectedColor: UIColor = ColorHelper.whiteColor()
    @Binding var selected: String
    var onChange: (_ id: String) -> ()

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            ForEach(0..<tabs.count, id: \.self) { i in
                if i > 0 {
                    Rectangle()
                        .background(Color(ColorHelper.darkGreyColor()))
                        .border(Color(ColorHelper.darkGreyColor()))
                        .frame(width: 1, height: 24, alignment: .center)
                        .padding(.horizontal, 4.0)
                    
                }
                Tab(tab: tabs[i], background: background, selectedBackground: selectedBackground, foregroundColor: color, selectedForegroundColor: selectedColor,
                    isSelected: selected == tabs[i].id,
                    onTap: { tabId in
                        self.selected = tabId
                        self.onChange(tabId)
                    })
            }
        })
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 32, maxHeight: 32, alignment: .center)
        .padding(4.0)
        .background(Color(background))
        .cornerRadius(4.0)
        .accessibility(hidden: true)
    }
}

struct Tabs_Previews: PreviewProvider {
    @State static private var tab = "test1"

    static var previews: some View {
        Tabs(tabs: [
            TabData(id: "test1", label: "Test"),
            TabData(id: "test2", label: "Test 2"),
            TabData(id: "test3", label: "Test 3")
        ],
        selected: $tab, onChange: { tabId in
            print(tabId)
        })
    }
}
