//
//  Pagination.swift
//  eChargeApp
//
//  Created by Raúl López Gutiérrez on 19/8/21.
//  Copyright © 2021 Trafineo. All rights reserved.
//

import SwiftUI

struct Pagination: View {
    @State var totalPages: Int = 0
    @State var currentPage: Int = 0
    var onPageChange: ((_ i: Int) -> ())? = nil
    private let maxDisplay: Int = 5

    var body: some View {
        if totalPages <= 0 {
            EmptyView()
        } else {
            HStack(alignment: .center, spacing: 0.0, content: {
                Button(action: {
                    currentPage = max(1, currentPage - 1)
                    onPageChange?(currentPage)
                }) {
                    Image(systemName: "chevron.backward")
                        .frame(width: 16.0, height: 16.0, alignment: .center)
                }
                    .padding(.horizontal, 10.0)
                    .accessibility(hidden: false)
                    .accessibility(identifier: "page_back")

                ForEach(0..<min(maxDisplay, totalPages)) { i in
                    Button(getButtonLabel(i)) {
                        let page = getPageForClick(i)
                        if page > 0 && page != currentPage {
                            currentPage = page
                            onPageChange?(currentPage)
                        }
                    }
                        .padding(.horizontal, 10.0)
                        .font(.system(size: 17.0, weight: getPageForClick(i) == currentPage ? .bold : .regular, design: .default))
                        .accessibility(hidden: false)
                        .accessibility(identifier: "page_\(getButtonLabel(i))")
                }

                Button(action: {
                    currentPage = min(totalPages, currentPage + 1)
                    onPageChange?(currentPage)
                }) {
                    Image(systemName: "chevron.forward")
                        .frame(width: 16.0, height: 16.0, alignment: .center)
                }
                    .accessibility(hidden: false)
                    .accessibility(identifier: "page_forward")
                    .padding(.horizontal, 10.0)
            })
                .foregroundColor(Color(ColorHelper.darkGreyColor()))
                .accessibility(hidden: true)
        }
    }
    
    private func getButtonLabel(_ i: Int) -> String {
        let page = getPageForClick(i)
        return page < 0 ? "..." : "\(page)"
    }
    
    private func getPageForClick(_ i: Int) -> Int {
        if totalPages < maxDisplay {
            return i + 1
        }

        let pagesLeft = totalPages - currentPage + 1
        if pagesLeft <= maxDisplay {
            return i + currentPage - maxDisplay + pagesLeft
        }

        if i == maxDisplay - 1 {
            return totalPages
        }

        return i == maxDisplay - 2 && totalPages > maxDisplay ? -1 : i + currentPage
    }
}

struct Pagination_Previews: PreviewProvider {
    static var previews: some View {
        Pagination(totalPages: 2, currentPage: 1)
            .previewLayout(.fixed(width: 300.0, height: 100.0))
        Pagination(totalPages: 3, currentPage: 1)
            .previewLayout(.fixed(width: 300.0, height: 100.0))
        Pagination(totalPages: 4, currentPage: 1)
            .previewLayout(.fixed(width: 300.0, height: 100.0))
        Pagination(totalPages: 8, currentPage: 7)
            .previewLayout(.fixed(width: 300.0, height: 100.0))
    }
}
