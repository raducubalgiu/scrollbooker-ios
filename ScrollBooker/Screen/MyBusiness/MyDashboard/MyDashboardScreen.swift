//
//  MyDashboardScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct MyDashboardScreen: View {
    let viewModel: MyDashboardViewModel
    let onBack: () -> Void

    @State private var selectedTab: MyDashboardTab = .appointments
    @Namespace private var indicatorNS

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: String(localized: "dashboard"), onBack: onBack)

            tabBar

            TabView(selection: $selectedTab) {
                MyDashboardBookingsTabView(viewModel: viewModel)
                    .tag(MyDashboardTab.appointments)

                MyDashboardPostsTabView()
                    .tag(MyDashboardTab.posts)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color.surfaceSB)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(MyDashboardTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(tab.title)
                            .font(.subheadline.bold())
                            .foregroundColor(selectedTab == tab ? .onSurfaceSB : .gray)

                        ZStack {
                            if selectedTab == tab {
                                Rectangle()
                                    .matchedGeometryEffect(id: "dashboardTabIndicator", in: indicatorNS)
                                    .frame(height: 3)
                                    .foregroundColor(.onSurfaceSB)
                            } else {
                                Color.clear.frame(height: 3)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, .xs)
        .background(Color.surfaceSB)
    }
}
