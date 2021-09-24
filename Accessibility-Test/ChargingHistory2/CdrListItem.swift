//
//  CdrListItem.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 10/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct CdrListItem: View {
    var cdr: Cdr
    @State var isShowingDetails = false
    @State var detailsCdr: Cdr? = nil

    var body: some View {
        HStack(alignment: .top,  content: {
            Image(uiImage: getAuthenticationImage(for: getAuthType(from: cdr.authMode ?? "")))
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(ColorHelper.darkGreyColor()))
                .frame(minWidth: 0, idealWidth: 14, maxWidth: 14, minHeight: 0, idealHeight: 24, maxHeight: 24, alignment: .center)
                .padding(.leading, 20.0)
                .padding(.top, 13.0)
                .padding([.bottom, .trailing],10.0)
                .accessibility(identifier: "ch_auth_img")
                .accessibility(hidden: false)
            VStack(alignment: .leading, spacing: .some(10.0), content: {
                HStack {
                    Image(uiImage: cdrIcon(from: cdr.type() ?? .Public))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18, alignment: .center)
                        .accessibility(identifier: "ch_cdr_icon")
                        .accessibility(hidden: false)
                    Text(cdr.formattedSessionStart() ?? "-")
                        .font(.system(size: 17))
                        .accessibility(identifier: "ch_formatted_session")
                        .accessibility(hidden: false)
                }
                    .foregroundColor(Color(ColorHelper.brandColor()))
                    .accessibility(hidden: true)
                
                if let address = cdr.address(), cdr.type() != .Home {
                    Text(address)
                        .multilineTextAlignment(.leading)
                        .accessibility(identifier: "ch_address")
                        .accessibility(hidden: false)
                        .fixedSize(horizontal: true, vertical: true)
                }
                
                if cdr.formattedPower() != nil || cdr.formattedTime() != nil {
                    HStack(alignment: .center, spacing: .some(5.0), content: {
                        if let power = cdr.formattedPower() {
                            HStack {
                                Image("ic_pricing-volume")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16.0, height: 16.0, alignment: .center)
                                    .accessibility(identifier: "ch_ic_pricing_volume")
                                    .accessibility(hidden: false)
                                Text(power)
                                    .accessibility(identifier: "ch_ic_pricing_volume_text")
                                    .accessibility(hidden: false)
                                    .fixedSize(horizontal: true, vertical: true)
                            }
                            .accessibility(hidden: true)
                        }
                        
                        if let time = cdr.formattedTime() {
                            HStack {
                                Image("ic_time")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16.0, height: 16.0, alignment: .center)
                                    .accessibility(identifier: "ch_ic_time")
                                    .accessibility(hidden: false)
                                Text(time)
                                    .accessibility(identifier: "ch_ic_time_text")
                                    .accessibility(hidden: false)
                                    .fixedSize(horizontal: true, vertical: true)
                            }
                            .accessibility(hidden: true)
                        }
                        
                        if cdr.type() == .Public {
                            HStack {
                                Image("icon-odometer")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16.0, height: 16.0, alignment: .center)
                                    .accessibility(identifier: "ch_icon_odometer")
                                    .accessibility(hidden: false)
                                Text(cdr.formattedOdometer() ?? "-")
                                    .accessibility(identifier: "ch_icon_odometer_text")
                                    .accessibility(hidden: false)
                                    .fixedSize(horizontal: true, vertical: true)

                            }
                            .accessibility(hidden: true)
                        }
                    })
                        .foregroundColor(Color(ColorHelper.ctaColor()))
                        .font(.system(size: 13.0))
                        .accessibility(hidden: true)
                }
            })
                .padding([.top, .bottom], 10.0)
                .accessibility(hidden: true)
            Spacer()
            HStack(alignment: .center, spacing: nil, content: {
                Image("arrow_listitem")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(ColorHelper.brandColor()))
                    .frame(width: 15, height: 15, alignment: .center)
                NavigationLink(destination: DeferView {
                    CdrDetails(cdr: detailsCdr ?? cdr)
                }, isActive: $isShowingDetails) {
                    EmptyView()
                }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            })
                .padding(.all, 10.0)
                .frame(minWidth: 0, idealWidth: 40, maxWidth: 40, minHeight: 0, idealHeight: 20, maxHeight: .infinity, alignment: .center)
                .background(Color(ColorHelper.paleGreyColor2()))
                .accessibility(identifier: "ch_arrow_navigate")
                .accessibility(hidden: false)
        })
            .background(Color(ColorHelper.paleGreyColor1()))
            .cornerRadius(10.0)
            .shadow(color: .black.opacity(0.35), radius: 1, x: 0, y: 0)
            .foregroundColor(Color(ColorHelper.darkGreyColor()))
            .font(.system(size: 15.0))
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
            .accessibility(hidden: true)
            .onTapGesture {
                self.detailsCdr = cdr
                self.isShowingDetails = true
            }
    }
}

struct CdrListItem_Previews: PreviewProvider {
    static var previews: some View {
        CdrListItem(cdr: Cdr(uid: "B08ACB6205D0EF29B27CBD49995E4DB8", idCpo: "20083023595904I00001TC15", evseId: "", authMode: "remote", sessionStart: "2020-09-01 15:46:52.0000", sessionEnd: "2020-09-01 15:46:59.0000", street: "Carretera de Visvique, 48", postalCode: "35412", city: "Las Palmas de Gran Canaria", country: "Spain", consumedEnergy: 1.38, consumedTime: 7.0, odometerValue: 60000, cdrTypeRaw: nil, latitude: 55.0, longitude: 55.0, operatorName: nil))
            .previewLayout(.fixed(width: 600.0, height: 150.0))
    }
}
