//
//  UserSocialScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI

enum UserSocialTab: String, CaseIterable, Identifiable {
    case reviews = "Recenzii"
    case followers = "Urmăritori"
    case following = "Urmărești"

    var id: String { rawValue }
}

struct UserSocialScreen: View {
    @State private var selection: UserSocialTab = .reviews
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(UserSocialTab.allCases) { tab in
                            Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.9) ) {
                                    selection = tab
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Text("\(tab.rawValue) 100")
                                        .font(.headline)
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
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // CONȚINUT SWIPE-ABIL
            TabView(selection: $selection) {
                ReviewsView()
                    .tag(UserSocialTab.reviews)
                FollowersView()
                    .tag(UserSocialTab.followers)
                FollowingView()
                    .tag(UserSocialTab.following)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // swipe left/right, fără buline
        }
    }
}



struct ReviewsView: View {
    var body: some View {
        Text("Lista recenzii")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct FollowersView: View {
    var body: some View {
        Text("Cine te urmărește")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct FollowingView: View {
    var body: some View {
        Text("Pe cine urmărești")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    UserSocialScreen()
}
