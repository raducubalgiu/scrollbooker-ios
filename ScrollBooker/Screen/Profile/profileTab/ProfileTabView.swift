//
//  ProfileTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileTabView: View {
    @State private var selectedTab: ProfileTab = .posts
    @Namespace private var indicatorNS
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.divider)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 0)
                
                HStack(spacing: 20) {
                    ForEach(ProfileTab.allCases) { tab in
                        Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.9) ) {
                            selectedTab = tab
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: tab.systemImage)
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
            }
            
            // CONȚINUT SWIPE-ABIL
            TabView(selection: $selectedTab) {
                ProfilePostsTabView()
                    .tag(ProfileTab.posts)
                ProfileProductsTabView()
                    .tag(ProfileTab.products)
                ProfileRepostsTabView()
                    .tag(ProfileTab.reposts)
                ProfileBookmarksTabView()
                    .tag(ProfileTab.bookmarks)
                ProfileInfoTabView()
                    .tag(ProfileTab.info)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview("Light") {
    ProfileTabView()
}

#Preview("Dark") {
    ProfileTabView()
        .preferredColorScheme(.dark)
}
