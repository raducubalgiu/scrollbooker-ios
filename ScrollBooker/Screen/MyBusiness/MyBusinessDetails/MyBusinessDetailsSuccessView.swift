//
//  MyBusinessDetailsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct MyBusinessDetailsSuccessView: View {
    let businessDetails: BusinessDetails
    let viewModel: MyBusinessDetailsViewModel

    @State private var selectedTab: Int = 0

    private let tabs = [
        String(localized: "summary"),
        String(localized: "photoGallery"),
        String(localized: "scheduleShort")
    ]

    var body: some View {
        VStack(spacing: 0) {
            PillTabBarView(tabs: tabs, selectedTab: $selectedTab)

            Divider()

            TabView(selection: $selectedTab) {
                MyBusinessSummaryTab(businessDetails: businessDetails)
                    .tag(0)

                MyBusinessGalleryTab(viewModel: viewModel)
                    .tag(1)

                MyBusinessSchedulesTab(viewModel: viewModel)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}
