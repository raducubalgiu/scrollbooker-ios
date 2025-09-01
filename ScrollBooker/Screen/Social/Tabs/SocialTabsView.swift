//
//  SocialTabsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

enum SocialTab: String, CaseIterable, Identifiable {
    case reviews = "Recenzii"
    case followers = "Urmăritori"
    case following = "Urmărești"

    var id: String { rawValue }
}

struct SocialTabsView: View {
    @Binding var selectedTab: SocialTab
    @Namespace private var indicatorNS
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.divider)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.top, 0)
            
            HStack(spacing: 20) {
                ForEach(SocialTab.allCases) { tab in
                    Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.9) ) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Text("\(tab.rawValue) 100")
                                .font(.subheadline)
                                .fontWeight(selectedTab == tab ? .bold : .medium)
                                .foregroundStyle(selectedTab == tab ? .primary : .secondary)
                            ZStack {
                                // indicator activ
                                if selectedTab == tab {
                                    Capsule()
                                        .matchedGeometryEffect(id: "underline", in: indicatorNS)
                                        .frame(height: 3)
                                        .offset(y: 8)
                                } else {
                                    Color.clear.frame(height: 3)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview("Light") {
    @Previewable @State var tab: SocialTab = .reviews
    
    SocialTabsView(
        selectedTab: $tab
    )
}

#Preview("Dark") {
    @Previewable @State var tab: SocialTab = .reviews
    
    SocialTabsView(
        selectedTab: $tab
    )
    .preferredColorScheme(.dark)
}
