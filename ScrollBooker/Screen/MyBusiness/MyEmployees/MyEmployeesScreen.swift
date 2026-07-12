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
