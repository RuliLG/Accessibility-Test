//
//  ChargingHistory.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 19/7/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct ChargingHistory: View {
    var dismissAction: (() -> Void)
    @State private var isFirstLoad = true
    @State private var refreshToggle = false
    @State private var isShowingSearch = false
    @State private var isShowingFilter = false
    @State private var showModal = false
    @State private var hideSelection = false
    @State private var selectedTab = CdrType.Public.rawValue
    @ObservedObject var filterModel = CdrFilterViewModel()
    @ObservedObject var cdrService = CdrService()
    @ObservedObject var userViewModel = UserModelCombine.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    NavigationLink(destination: DeferView { ChargingHistorySearch() }, isActive: $isShowingSearch) {
                        EmptyView()
                    }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                    NavigationLink(destination: DeferView {
                        ChargingHistoryFilter(onSave: {
                            filterModel.refresh()
                            cdrService.currentPage = 1
                            if filterModel.hasFilters() {
                                selectedTab = ""
                            } else {
                                selectedTab = filterModel.showOnly[0].rawValue
                            }
                            
                            filterModel.refresh()
                            cdrService.fetchCdrs(of: (filterModel.showOnly.isEmpty ? [.Public] : filterModel.showOnly), shouldReset: true)
                        })
                    }, isActive: $isShowingFilter) {
                        EmptyView()
                    }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    LinearGradient(gradient: Gradient(
                                    colors: [
                                        Color(ColorHelper.startGradientColor()),
                                        Color(ColorHelper.endGradientColor())
                                    ]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Navbar(title: SchemeHelper.localizedText(forKey: "menu_charging_history"), dismissAction: dismissAction, titleColor: .white, right: {
                                EmptyView()
//                                HStack {
//                                    RoundedImageButton(imageName: "search") {
//                                        if let _ = userViewModel.user {
//                                            self.isShowingSearch = true
//                                        }
//                                    }
//                                        .disabled(userViewModel.user == nil)
//                                        .opacity(userViewModel.user == nil ? 0.5 : 1)
//                                        .accessibility(identifier: "ch_search_btn")
//                                        .accessibility(hidden: false)
//
//                                    ZStack(alignment: .topLeading) {
//                                        RoundedImageButton(imageName: filterModel.hasFilters() ? "filter-active" : "filter") {
//                                            if let _ = userViewModel.user {
//                                                self.isShowingFilter = true
//                                            }
//                                        }
//                                            .disabled(userViewModel.user == nil)
//                                            .accessibility(identifier: "ch_filter_btn")
//                                            .accessibility(hidden: false)
//                                        if filterModel.hasFilters() {
//                                            Text("\(filterModel.numberOfFilters())")
//                                                .font(.system(size: 12.0))
//                                                .bold()
//                                                .frame(width: 16.0, height: 16.0, alignment: .center)
//                                                .background(Color(ColorHelper.redColor()))
//                                                .foregroundColor(.white)
//                                                .cornerRadius(999)
//                                        }
//                                    }
//                                        .opacity(userViewModel.user == nil ? 0.5 : 1)
//                                        .accessibility(hidden: true)
//                            }
//                                .accessibility(hidden: true)
                        }, modal: ChargingHistoryLegendModal.init, hasModal: true)
                        VStack(alignment: .center) {
                            if filterModel.hasFilters() {
                                Text(SchemeHelper.localizedText(forKey: "charging_history_based_on_filters"))
                                    .foregroundColor(Color(ColorHelper.whiteColor()))
                                    .font(.system(size: 12.0))
                                    .accessibility(hidden: false)
                                    .accessibility(identifier: "ch_based_on_filters")
                            }

                            HStack(alignment: .center, spacing: .some(40.0), content: {
                                iconWithTextAndDescription(image: "Illu_totalenergy", text: getTotalEnergy(), description: SchemeHelper.localizedText(forKey: "charging_history_total_energy"))
                                iconWithTextAndDescription(image: "Illu_totaltime", text: getTotalTime(), description: SchemeHelper.localizedText(forKey: "charging_history_total_time"))
                            })
                                .padding(.bottom, 40.0)
                                .accessibility(hidden: true)
                        }
                            .accessibility(hidden: true)
                        VStack {
                            Tabs(
                                tabs: [
                                    TabData(id: CdrType.Public.rawValue, label: cdrText(from: .Public), image: cdrIcon(from: .Public)),
                                    TabData(id: CdrType.Depot.rawValue, label: cdrText(from: .Depot), image: cdrIcon(from: .Depot)),
                                    TabData(id: CdrType.Home.rawValue, label: cdrText(from: .Home), image: cdrIcon(from: .Home))
                                ],
                                selectedBackground: ColorHelper.varianceColor2(),
                                selectedColor: ColorHelper.darkGreyColor(),
                                selected: $selectedTab,
                                onChange: { tabId in
                                    filterModel.editableShowOnly = [cdrType(from: tabId)]
                                    filterModel.editableTimeframe = .all
                                    filterModel.save()
                                    selectedTab = tabId
                                    self.cdrService.fetchCdrs(of: [cdrType(from: tabId)], shouldReset: true)
                                }
                            )
                            .padding(10)
                            
                            if cdrService.cdrCount == 0 {
                                Spacer()
                                if filterModel.hasFilters() {
                                    EmptyState(text: SchemeHelper.localizedText(forKey: "charging_history_filter_empty"), imageName: "filter")
                                } else {
                                    EmptyState(text: SchemeHelper.localizedText(forKey: "charging_history_no_cdrs"), imageName: "icon_chargehistory")
                                }
                            }
                            
//                            if userViewModel.user == nil {
//                                Spacer()
//                                PleaseLogin()
//                                    .padding(.all, 20)
//                            } else {
                                if cdrService.cdrCount == 0 {
                                    Spacer()
                                } else {
                                    HStack(alignment: .center, spacing: nil, content: {
                                        Text(
                                            SchemeHelper.localizedText(forKey: "charging_history_results")
                                                .replacingOccurrences(of: "{current}", with: "\(cdrService.cdrs.count)")
                                                .replacingOccurrences(of: "{total}", with: "\(cdrService.cdrCount)")
                                        )
                                            .foregroundColor(Color(ColorHelper.darkGreyColor()))
                                            .font(.system(size: 15.0))
                                            .padding(.leading, 20.0)
                                            .accessibility(identifier: "ch_results")
                                            .accessibility(hidden: false)
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                showModal = true
                                            }
                                        }) {
                                            HStack {
                                                Image("ic_export_data")
                                                    .renderingMode(.original)
                                                    .padding([.leading], 10)
                                                    .padding([.top,.bottom],5)
                                                Text(SchemeHelper.localizedText(forKey: "charging_history_export_data_buttom_text"))
                                                    .padding(.trailing, 10)
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 12.0))
                                            }
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color(ColorHelper.greyColor()), lineWidth: 0.5)
                                            )
                                        }
                                            .padding(.trailing, 20)
                                            .disabled(filterModel.hasFilters())
                                            .opacity(filterModel.hasFilters() ? 0.5 : 1.0)
                                            .accessibility(identifier: "ch_export_btn")
                                            .accessibility(hidden: false)
                                    })
                                        .accessibility(hidden: true)
                                    ScrollView {
                                        VStack(content: {
                                            ForEach(cdrService.cdrs, id: \.uid) { cdr in
                                                CdrListItem(cdr: cdr)
                                                    .accessibility(hidden: true)
                                            }
                                        })
                                            .padding(10.0)
                                            .accessibility(hidden: true)
                                    }
                                        .accessibility(hidden: true)
                                    if cdrService.totalPages > 1 {
                                        HStack {
                                            Spacer()
                                            Pagination(totalPages: cdrService.totalPages, currentPage: cdrService.currentPage) { page in
                                                print("Tap in page \(page)")
                                                cdrService.goToPage(page)
                                            }
                                                .accessibility(identifier: "ch_pagination")
                                                .accessibility(hidden: false)
                                            Spacer()
                                        }
                                            .padding(.bottom, 20.0)
                                            .accessibility(hidden: true)
                                    }
                                }
//                            }
                        }
                        .background(RoundedCorners(color: .white, tl: 20.0, tr: 20.0, bl: 0, br: 0))
                        .frame(minHeight: 0, idealHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.bottom)
                        .accessibility(hidden: true)
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    if isFirstLoad {
                        filterModel.editableShowOnly = [.Public]
                        filterModel.editableTimeframe = .all
                        filterModel.save()
                        selectedTab = CdrType.Public.rawValue
                        isFirstLoad = false
                        filterModel.refresh()
                        cdrService.fetchCdrs(of: (filterModel.showOnly.isEmpty ? [.Public] : filterModel.showOnly), shouldReset: true)
                    }
                }
                
                if showModal {
                    ModalBase(content: {
                        CharginHistoryExportDataModal(close: {
                            withAnimation {
                                self.showModal = false
                            }
                        })
                    }, showModal: $showModal)
                }
            }
        }
    }
    
    func getTotalEnergy() -> String {
        return LocaleHelper.getFormattedKwh(cdrService.totalEnergy, decimals: 0)
    }
    
    func getTotalTime() -> String {
        return Duration.from(seconds: cdrService.totalTime, format: .short)
    }
    
    func iconWithTextAndDescription(image: String, text: String, description: String) -> some View {
        return VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48, alignment: .center)
                .accessibility(identifier: "ch_\(image.description)")
                .accessibility(hidden: false)
            Text(text)
                .foregroundColor(.white)
                .accessibility(identifier: "ch_\(text.description)")
                .accessibility(hidden: false)
            Text(description)
                .foregroundColor(.white)
                .accessibility(identifier: "ch_\(description.description)")
                .accessibility(hidden: false)
        }
            .accessibility(hidden: true)
    }
}

struct ChargingHistory_Previews: PreviewProvider {
    static var previews: some View {
        ChargingHistory {
            // ...
        }
    }
}
