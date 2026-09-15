//
//  MyEmployeesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyEmployeesScreen: View {
    let viewModel: MyEmployeesViewModel
    let onBack: () -> Void
    let onNavigateToSearchUser: () -> Void
 
    @State private var selectedTab: Int = 0
    
    private let tabs = [
        String(localized: "employees"),
        String(localized: "employmentRequests")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "employees"),
                enableBack: true,
                onBack: onBack
            )
            
            PillTabBarView(tabs: tabs, selectedTab: $selectedTab)

            Divider()
            
            TabView(selection: $selectedTab) {
                EmployeesTab(viewModel: viewModel)
                    .tag(0)
                
                EmploymentRequestsTab(
                    viewModel: viewModel,
                    onNavigateToSearchUser: onNavigateToSearchUser
                )
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}
