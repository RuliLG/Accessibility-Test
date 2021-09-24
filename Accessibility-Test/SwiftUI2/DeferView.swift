//
//  DeferView.swift
//  eChargeApp
//
//  Created by Raul Lopez on 21/9/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct DeferView<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        content()          // << everything is created here
    }
}
