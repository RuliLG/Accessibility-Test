//
//  View+Visibiliy.swift
//  eChargeApp
//
//  Created by Pedro Sánchez on 30/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//
import SwiftUI

import Foundation

extension View {
   func visibility(hidden: Bool) -> some View {
      modifier(VisibilityStyle(hidden: hidden))
   }
}
