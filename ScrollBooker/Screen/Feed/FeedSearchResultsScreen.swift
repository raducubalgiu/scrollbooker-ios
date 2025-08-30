//
//  FeedSearchResultsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct FeedSearchResultsScreen: View {
    @State private var selection: SearchTab = .forYou
    @Namespace private var indicatorNS
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(SearchTab.allCases) { tab in
                        Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.9) ) {
                            selection = tab
                        }
                        } label: {
                            VStack(spacing: 6) {
                                Text("\(tab.rawValue) 100")
                                    .font(.subheadline)
                                    .fontWeight(selection == tab ? .bold : .medium)
                                    .foregroundStyle(selection == tab ? .primary : .secondary)
                                ZStack {
                                    // indicator activ
                                    if selection == tab {
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
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(.divider)
                    .frame(height: 1)
            }
        }
        
        // CONȚINUT SWIPE-ABIL
        TabView(selection: $selection) {
            ForYouSearchTab()
                .tag(SearchTab.forYou)
            UsersSearchTab()
                .tag(SearchTab.users)
            LastMinuteSearchTab()
                .tag(SearchTab.lastMinute)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
    
#Preview("Light") {
    FeedSearchResultsScreen()
}

#Preview("Dark") {
    FeedSearchResultsScreen()
        .preferredColorScheme(.dark)
}
