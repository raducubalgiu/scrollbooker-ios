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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        let isSelected = selectedTab == index

                        Text(tabs[index])
                            .font(.subheadline)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .foregroundColor(isSelected ? .white : .secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color.primarySB : Color.clear)
                            .cornerRadius(50)
                            .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            .onTapGesture { selectedTab = index }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }

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
