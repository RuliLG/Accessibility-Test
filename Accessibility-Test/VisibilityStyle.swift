//
//  VisibilityStyle.swift
//  eChargeApp
//
//  Created by Pedro Sánchez on 30/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct VisibilityStyle: ViewModifier {
   
   let hidden: Bool
   @ViewBuilder
   func body(content: Content) -> some View {
      if hidden {
         content.hidden()
      } else {
         content
      }
   }
}
