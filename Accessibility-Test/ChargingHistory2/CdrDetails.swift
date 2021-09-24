//
//  CdrDetails.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 17/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI
import MapKit

struct CdrDetails: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var cdr: Cdr
    @State var region: MKCoordinateRegion? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                Navbar(title: SchemeHelper.localizedText(forKey: "charging_history_details_header"), dismissAction: {
                    presentationMode.wrappedValue.dismiss()
                }, titleColor: Color.white, right: {

                }, modal: {

                })

                VStack(alignment: .center, spacing: 15.0) {
                    Image(uiImage: cdrIcon(from: cdr.type()!))
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32.0, height: 32.0, alignment: .center)
                        .accessibility(identifier: "ch_detail_cdricon")
                        .accessibility(hidden: false)
                    if cdr.type() != CdrType.Home {
                        if let address = cdr.address() {
                            Text(address)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 21.0))
                                .accessibility(identifier: "ch_detail_address")
                                .accessibility(hidden: false)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    } else {
                        Text(SchemeHelper.localizedText(forKey: "charging_history_home"))
                            .multilineTextAlignment(.center)
                            .font(.system(size: 21.0))
                            .accessibility(identifier: "ch_detail_home")
                            .accessibility(hidden: false)
                    }

                    Text("EVSE-ID: \(cdr.evseId ?? "-")")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 15.0))
                        .accessibility(identifier: "ch_detail_evse-id")
                        .accessibility(hidden: false)

                    if cdr.type() == .Home {
                        Image(isAralScheme ? "icon_homecharging_aral" : "icon_homecharging_bp")
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150.0, height: 150.0, alignment: .center)
                            .accessibility(identifier: "icon_home_charging")
                            .accessibility(hidden: false)
                        Spacer()
                    }
                }
                    .foregroundColor(.white)
                    .accessibility(hidden: true)
            }
            .padding(.bottom, 30.0)
            .background(LinearGradient(gradient: Gradient(
                                        colors: [
                                            Color(ColorHelper.startGradientColor()),
                                            Color(ColorHelper.endGradientColor())
                                        ]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                            .edgesIgnoringSafeArea(.top))
            .accessibility(hidden: true)

            VStack {
                if let _ = region, cdr.type() != .Home {
//                    SwiftUIMapView.MapView(
//                        mapType: .standard,
//                        region: self.$region,
//                        isZoomEnabled: true,
//                        isScrollEnabled: true,
//                        showsUserLocation: false,
//                        userTrackingMode: .none,
//                        annotations: annotations
//                    )
//                        .frame(maxWidth: .infinity, minHeight: 150.0, idealHeight: 150.0, maxHeight: 150.0, alignment: .center)
//                        .accessibility(identifier: "ch_detail_map")
//                        .accessibility(hidden: false)
                }

                VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        if let operatorName = cdr.operatorName {
                            detailRow(imageName: "icon_operator", title: SchemeHelper.localizedText(forKey: "operator"), value: operatorName)
                        }
                        if cdr.type() != .Home {
                            detailRow(imageName: "icon-authentication", title: SchemeHelper.localizedText(forKey: "common_authentication"), value: getAuthenticationLocalizedName(from: getAuthType(from: cdr.authMode ?? "")))
                        }
                        VStack(alignment: .leading, spacing: 3.0) {
                            if let sessionStart = cdr.formattedSessionStart() {
                                detailRow(imageName: "ic_per-minute", title: SchemeHelper.localizedText(forKey: "common_session_start"), value: sessionStart)
                            }
                            if let sessionEnd = cdr.formattedSessionEnd() {
                                detailRow(imageName: nil, title: SchemeHelper.localizedText(forKey: "common_session_end"), value: sessionEnd)
                            }
                            if let duration = cdr.formattedTime() {
                                detailRow(imageName: nil, title: SchemeHelper.localizedText(forKey: "common_duration"), value: duration)
                            }
                        }
                        if let energy = cdr.formattedPower() {
                            detailRow(imageName: "ic_pricing-volume", title: SchemeHelper.localizedText(forKey: "charging_history_energy_consumed"), value: energy)
                        }
                        if let odometer = cdr.formattedOdometer(), cdr.type() == .Public {
                            detailRow(imageName: "icon-odometer", title: SchemeHelper.localizedText(forKey: "charging_history_odometer_status"), value: odometer)
                        }
                        Spacer()
                            .frame(maxHeight: 40.0)
                    }
                        .padding(15.0)
                        .padding(.top, 20.0)
                        .background(Color(ColorHelper.paleGreyColor2()))
                        .cornerRadius(7.0)
                        .padding(.horizontal, 15.0)
                        .padding(.top, -20)
                    Image("ripped_card")
                        .renderingMode(.template)
                        .resizable()
                        .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, minHeight: 14.0, idealHeight: 14.0, maxHeight: 14.0, alignment: .center)
                        .foregroundColor(Color(ColorHelper.paleGreyColor2()))
                        .padding(.horizontal, 15.0)
                        .padding(.top, -7.0)
                }
                Spacer()
            }
                .padding(.top, 0.0)
                .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let coordinates = cdr.coordinates() {
                region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
    }
    
    private func detailRow(imageName: String?, title: String, value: String) -> some View {
        HStack {
            if let imageName = imageName {
                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16.0, height: 16.0, alignment: .center)
                    .accessibility(identifier: "ch_detail_image_row_\(imageName)")
                    .accessibility(hidden: false)
            } else {
                Color(ColorHelper.paleGreyColor2())
                    .frame(minWidth: 16.0, idealWidth: 16.0, maxWidth: 16.0, minHeight: 1.0, idealHeight: 1.0, maxHeight: 1.0, alignment: .center)
            }
            HStack(alignment: .center, spacing: nil, content: {
                Text(title)
                    .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .accessibility(identifier: "ch_detail_title_row_\(title)")
                    .accessibility(hidden: false)
                Text(value)
                    .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .accessibility(identifier: "ch_detail_value_row_\(title)")
                    .accessibility(hidden: false)
            })
                .accessibility(hidden: true)
        }
            .foregroundColor(Color(ColorHelper.darkGreyColor()))
            .font(.system(size: 15.0))
            .accessibility(hidden: true)
    }
}

struct CdrDetails_Previews: PreviewProvider {
    static var previews: some View {
        CdrDetails(cdr: Cdr(uid: "test", idCpo: "DE*CPO+123412323+1", evseId: "DE*CPO+123412323+1", authMode: "card", sessionStart: "2021-04-15T06:36:00.000", sessionEnd: "2021-04-15T15:18:00.000", street: "Frohnhauser Straße 366", postalCode: "45144", city: "Essen", country: "Deutschland", consumedEnergy: 54.8455, consumedTime: 31355, odometerValue: 37783, cdrTypeRaw: CdrType.Home.rawValue, latitude: 55.0, longitude: 55.0, operatorName: nil))
        CdrDetails(cdr: Cdr(uid: "test", idCpo: "DE*CPO+123412323+1", evseId: "DE*CPO+123412323+1", authMode: "card", sessionStart: "2021-04-15 06:36:00", sessionEnd: "2021-04-15 15:18:00", street: "Frohnhauser Straße 366", postalCode: "45144", city: "Essen", country: "Deutschland", consumedEnergy: 54.8455, consumedTime: 31355, odometerValue: 37783, cdrTypeRaw: CdrType.Depot.rawValue, latitude: 55.0, longitude: 55.0, operatorName: "Test"))
        CdrDetails(cdr: Cdr(uid: "test", idCpo: "DE*CPO+123412323+1", evseId: "DE*CPO+123412323+1", authMode: "card", sessionStart: "2021-04-15 06:36:00", sessionEnd: "2021-04-15 15:18:00", street: "Frohnhauser Straße 366", postalCode: "45144", city: "Essen", country: "Deutschland", consumedEnergy: 54.8455, consumedTime: 31355, odometerValue: 37783, cdrTypeRaw: CdrType.Public.rawValue, latitude: 55.0, longitude: 55.0, operatorName: "Test"))
    }
}
