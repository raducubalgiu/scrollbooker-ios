//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

enum SocialTab: String, CaseIterable, Identifiable {
    case reviews = "Recenzii"
    case followers = "Urmăritori"
    case following = "Urmărești"

    var id: String { rawValue }
}

struct SocialScreen: View {
    @State private var selection: SocialTab = .reviews
    @Namespace private var indicatorNS
    
    var body: some View {
        Header(title: "@radu_balgiu")
        
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.divider)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 0)
                
                HStack(spacing: 20) {
                    ForEach(SocialTab.allCases) { tab in
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
            
            // CONȚINUT SWIPE-ABIL
            TabView(selection: $selection) {
                ReviewsTabView()
                    .tag(SocialTab.reviews)
                FollowersTabView()
                    .tag(SocialTab.followers)
                FollowingsTabView()
                    .tag(SocialTab.following)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // swipe left/right, fără buline
        }
    }
}

#Preview {
    SocialScreen()
}
