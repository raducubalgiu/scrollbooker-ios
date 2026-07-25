//
//  ReviewsTabBarView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct ReviewsTabBarView<Tab: CaseIterable & Hashable & RawRepresentable>: View {
    @Binding var selectedTab: Tab
    let animationNamespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                ForEach(Array(Tab.allCases), id: \.self) { tab in
                    let isSelected = selectedTab == tab
                    let tabTitle = (tab.rawValue as? String) ?? ""
                    
                    Text(tabTitle)
                        .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? .onSurfaceSB : .onBackgroundSB)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(height: 42)
                        .background(
                            Group {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 50)
                                        .fill(Color.surfaceSB)
                                        .matchedGeometryEffect(id: "activeTabBackground", in: animationNamespace)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.clear)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
            Rectangle()
                .fill(Color.dividerSB)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemBackground))
    }
}
