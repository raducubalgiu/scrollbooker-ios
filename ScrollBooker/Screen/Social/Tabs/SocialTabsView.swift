//
//  SocialTabsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

struct SocialTabsView: View {
    @Binding var selectedTab: SocialTab
    @Namespace private var indicatorNS
    
    let followersCount: Int
    let followingsCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(SocialTab.allCases) { tab in
                    Button {
                        selectTab(tab)
                    } label: {
                        VStack(spacing: 8) {
                            Text(labelText(for: tab))
                                .font(.subheadline)
                                .fontWeight(selectedTab == tab ? .bold : .medium)
                                .foregroundStyle(selectedTab == tab ? Color.primary : Color.secondary)
                            
                            ZStack {
                                if selectedTab == tab {
                                    Capsule()
                                        .fill(Color.primary)
                                        .matchedGeometryEffect(id: "underline", in: indicatorNS)
                                        .frame(height: 3)
                                } else {
                                    Capsule()
                                        .fill(Color.clear)
                                        .frame(height: 3)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Rectangle()
                .fill(Color.dividerSB)
                .frame(height: 1)
        }
    }
    
    private func labelText(for tab: SocialTab) -> String {
        switch tab {
        case .reviews:
            return "\(tab.rawValue) 0"
        case .followers:
            return "\(tab.rawValue) \(followersCount)"
        case .following:
            return "\(tab.rawValue) \(followingsCount)"
        }
    }
    
    private func selectTab(_ tab: SocialTab) {
        let animation = Animation.spring(response: 0.25, dampingFraction: 0.85)
        withAnimation(animation) {
            selectedTab = tab
        }
    }
}
