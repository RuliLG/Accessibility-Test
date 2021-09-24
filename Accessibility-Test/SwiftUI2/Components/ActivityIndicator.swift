//
//  activityIndicator.swift
//  Transitions
//
//  Created by Pedro Sánchez on 29/8/21.
//

import SwiftUI

struct ActivityIndicator: View {
 
    @State private var isLoading = false
 
    var body: some View {
        VStack{
            Text("Exporting data...")
                .font(.system(size: 17.0))
                .foregroundColor(Color(ColorHelper.darkGreyColor()))
                .padding(.all, 40)
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 14)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(Color(ColorHelper.availableColor()), lineWidth: 7)
                    .frame(width: 100, height: 100)
                    .transition(.identity)
                    .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .onAppear() {
                        self.isLoading = true
                    }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
