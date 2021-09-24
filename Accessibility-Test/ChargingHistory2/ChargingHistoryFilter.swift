//
//  ChargingHistoryFilter.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 14/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

enum ChargingHistoryTimeframe: String {
    case all, lastWeek, lastMonth, lastTwoMonths
}

func cdrTimeframeText(_ from: ChargingHistoryTimeframe) -> String {
    switch from {
    case .all:
        return SchemeHelper.localizedText(forKey: "charging_history_timeframe_all")
    case .lastWeek:
        return SchemeHelper.localizedText(forKey: "charging_history_timeframe_last_week")
    case .lastMonth:
        return SchemeHelper.localizedText(forKey: "charging_history_timeframe_last_month")
    case .lastTwoMonths:
        return SchemeHelper.localizedText(forKey: "charging_history_timeframe_last_two_months")
    }
}

struct ChargingHistoryFilter: View {
    var onSave: (() -> ())? = nil
    @ObservedObject var filterModel = CdrFilterViewModel()
    @State var isShowingTimeframeOptions = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(SchemeHelper.localizedText(forKey: "common_cancel")) {
                        filterModel.refresh()
                        presentationMode.wrappedValue.dismiss()
                    }
                        .foregroundColor(Color(ColorHelper.brandColor()))
                        .accessibility(hidden: false)
                        .accessibility(identifier: "ch_filter_cancel")
                    Spacer()
                    Text(SchemeHelper.localizedText(forKey: "filter_nav_title"))
                        .foregroundColor(Color(ColorHelper.darkGreyColor()))
                        .accessibility(identifier: "ch_filter_title")
                        .accessibility(hidden: false)
                    Spacer()
                    Button(SchemeHelper.localizedText(forKey: "common_reset")) {
                        filterModel.reset()
                    }
                        .foregroundColor(Color(ColorHelper.brandColor()))
                        .accessibility(identifier: "ch_filter_reset")
                        .accessibility(hidden: false)
                }
                    .accessibility(hidden: true)
                
                Color(ColorHelper.paleGreyColor1())
                    .frame(minHeight: 1, idealHeight: 1, maxHeight: 1, alignment: .center)
                Spacer()
                    .frame(height: 20.0)
                VStack(alignment: .leading, spacing: 10.0, content: {
                    Text(SchemeHelper.localizedText(forKey: "charging_history_filter_show_only"))
                        .bold()
                        .foregroundColor(Color(ColorHelper.darkGreyColor()))
                        .accessibility(identifier: "ch_filter_show_only")
                        .accessibility(hidden: false)
                    HStack(alignment: .center, spacing: 20.0, content: {
                        option(value: .Public)
                        option(value: .Depot)
                        option(value: .Home)
                    })
                        .accessibility(hidden: true)
                })
                    .accessibility(hidden: true)
                
                VStack(alignment: .leading, spacing: 10.0, content: {
                    Color(ColorHelper.paleGreyColor1())
                        .frame(minHeight: 1, idealHeight: 1, maxHeight: 1, alignment: .center)

                    Spacer()
                        .frame(height: 10.0)

                    Text(SchemeHelper.localizedText(forKey: "charging_history_filter_select_timeframe"))
                        .bold()
                        .foregroundColor(Color(ColorHelper.darkGreyColor()))
                        .accessibility(identifier: "ch_filter_select_timeframe")
                        .accessibility(hidden: false)
                    HStack {
                        HStack {
                            Text(cdrTimeframeText(filterModel.editableTimeframe))
                            Spacer()
                            Image("ic_group-arrow-down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16.0, height: 12.0, alignment: .center)
                        }
                            .font(.system(size: 15.0))
                            .foregroundColor(Color(ColorHelper.darkGreyColor()))
                            .padding(.horizontal, 20.0)
                            .padding(.vertical, 10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12.0)
                                    .stroke(Color(ColorHelper.greyColor()))
                            )
                            .onTapGesture {
                                isShowingTimeframeOptions = true
                            }
                            .accessibility(identifier: "ch_filter_dropdown")
                            .accessibility(hidden: false)
                    }
                        .padding(.trailing, 40.0)
                    
                    Spacer()
                        .frame(height: 10.0)
                    Color(ColorHelper.paleGreyColor1())
                        .frame(minHeight: 1, idealHeight: 1, maxHeight: 1, alignment: .center)
                })
                .padding(.vertical, 30.0)
                
                Spacer()
                
                Button(action: {
                    filterModel.save()
                    onSave?()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Spacer()
                        Text(SchemeHelper.localizedText(forKey: "common_apply"))
                        Spacer()
                    }
                }
                    .padding(.vertical, 20.0)
                    .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                    .background(Color(ColorHelper.ctaColor()))
                    .foregroundColor(.white)
                    .cornerRadius(12.0)
                    .padding(.bottom, 20.0)
            }
                .padding(.horizontal, 30.0)
            
            if isShowingTimeframeOptions {
                VStack(alignment: .leading, spacing: nil) {
                    Spacer()
                    Picker(SchemeHelper.localizedText(forKey: "charging_history_filter_select_timeframe"), selection: $filterModel.editableTimeframe) {
                        Text(cdrTimeframeText(.all)).tag(ChargingHistoryTimeframe.all)
                        Text(cdrTimeframeText(.lastWeek)).tag(ChargingHistoryTimeframe.lastWeek)
                        Text(cdrTimeframeText(.lastMonth)).tag(ChargingHistoryTimeframe.lastMonth)
                        Text(cdrTimeframeText(.lastTwoMonths)).tag(ChargingHistoryTimeframe.lastTwoMonths)
                    }
                    .labelsHidden()
                    .pickerStyle(DefaultPickerStyle())
                    .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                    .background(Color.white)
                    .overlay(
                        GeometryReader { gp in
                            VStack {
                                Button(action: {
                                    self.isShowingTimeframeOptions = false
                                }) {
                                    HStack {
                                        Spacer()
                                        Text(SchemeHelper.localizedText(forKey: "common_done"))
                                            .foregroundColor(Color(ColorHelper.brandColor()))
                                            .padding(.vertical, 8.0)
                                    }
                                }
                                    .padding(.horizontal, 20.0)
                                    .background(Color(ColorHelper.paleGreyColor1()))
                                Spacer()
                            }
                            .frame(width: gp.size.width, height: gp.size.height - 12)
                        }
                    )
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            filterModel.refresh()
        }
    }
    
    private func option(value: CdrType) -> some View {
        let isContained = filterModel.editableShowOnly.contains(value)
        return Button(action: {
            if filterModel.editableShowOnly.contains(value) {
                if filterModel.editableShowOnly.count > 1 {
                    filterModel.editableShowOnly = filterModel.editableShowOnly.filter { $0 != value }
                }
            } else {
                filterModel.editableShowOnly.append(value)
            }
        }) {
            VStack(alignment: .center, spacing: 10.0) {
                Image(uiImage: cdrIcon(from: value))
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50.0, height: 50.0, alignment: .center)
                    .foregroundColor(.black)
                    .accessibility(identifier: "ch_filter_option_icon_\(value.rawValue)")
                    .accessibility(hidden: false)
                Text(cdrText(from: value))
                    .foregroundColor(Color(ColorHelper.darkGreyColor()))
                    .font(.system(size: 15.0))
                    .accessibility(identifier: "ch_filter_option_text_\(value.rawValue)")
                    .accessibility(hidden: false)
            }
                .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                .padding(5.0)
                .background(isContained ? Color.white : Color(ColorHelper.paleGreyColor1()))
                .accessibility(hidden: true)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(isContained ? Color(ColorHelper.ctaColor()) : Color(ColorHelper.paleGreyColor2()))
                )
            
            
            
        }
            .accessibility(hidden: true)
    }
}

struct ChargingHistoryFilter_Previews: PreviewProvider {
    static var previews: some View {
        ChargingHistoryFilter()
    }
}
