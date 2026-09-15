//
//  PillTabBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct PillTabBarView: View {
    let tabs: [String]
    @Binding var selectedTab: Int

    var body: some View {
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
    }
}
