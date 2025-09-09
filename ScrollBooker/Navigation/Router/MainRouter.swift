//
//  MainRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CustomTabBarItem: Identifiable, Hashable {
    let id = UUID()
    let tab: MainTab
    let title: String
    let systemImage: String
    var badge: Int = 0
}

struct CustomTabBar: View {
    @Binding var selected: MainTab
    let items: [CustomTabBarItem]
    var background: Color = Color.backgroundSB
    private let barHeight: CGFloat = 56

    var body: some View {
        ZStack {
            Spacer()
            
            HStack {
                ForEach(items) { item in
                    Button {
                        selected = item.tab
                    } label: {
                        VStack(spacing: 4) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: item.systemImage)
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(foregroundColor(for: item.tab))
                                if item.badge > 0 {
                                    Text("\(item.badge)")
                                        .font(.system(size: 12, weight: .bold))
                                        .padding(.horizontal, 7.5)
                                        .padding(.vertical, 2)
                                        .background(Capsule().fill(Color.errorSB))
                                        .foregroundStyle(.white)
                                        .offset(x: 15, y: -5)
                                }
                            }
                            Text(item.title)
                                .font(.system(size: 11.5))
                                .foregroundColor(foregroundColor(for: item.tab))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: barHeight)
            .padding(.horizontal, 8)
        }
        // fundalul se întinde și sub home indicator, dar NU schimbă înălțimea layout-ului
        .background(
            Rectangle()
                .fill(background)
                //.frame(height: barHeight + insets.bottom)
                .ignoresSafeArea(edges: .bottom)
                .overlay(Divider(), alignment: .top)
        )
    }
    
    private func foregroundColor(for tab: MainTab) -> Color {
        if selected == .feed && tab == .feed {
            return Color.white
        } else {
            return (selected == tab) ? Color.onBackgroundSB : .gray
        }
    }
}

struct MainRouter: View {
    @StateObject private var router = Router()
    @EnvironmentObject private var session: SessionManager
    
    var body: some View {
        Group {
            switch router.selectedTab {
            case .feed:
                FeedTabRouter(router: router)
            case .inbox:
                InboxTabRouter(router: router)
            case .search:
                SearchTabRouter(router: router)
            case .appointments:
                AppointmentsTabRouter(router: router)
            case .profile:
                MyProfileTabRouter(router: router)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(
                selected: $router.selectedTab,
                items: [
                    .init(tab: .feed, title: "Acasa", systemImage: "house.fill"),
                    .init(tab: .inbox, title: "Inbox", systemImage: "bell.fill", badge: 10),
                    .init(tab: .search, title: "Cauta", systemImage: "magnifyingglass"),
                    .init(tab: .appointments, title: "Rezervari", systemImage: "calendar", badge: 20),
                    .init(tab: .profile, title: "Profil", systemImage: "person.fill")
                ],
                background: router.selectedTab == .feed ? Color.black : Color.backgroundSB
            )
        }
        
//        TabView(selection: $router.selectedTab) {
//           FeedTabRouter(router: router)
//                .tabItem { Label("home", systemImage: "house") }
//                .tag(MainTab.feed)
//            
//            InboxTabRouter(router: router)
//                 .tabItem { Label("inbox", systemImage: "bell") }
//                 .tag(MainTab.inbox)
//                 .badge(10)
//            
//            SearchTabRouter(router: router)
//                 .tabItem { Label("search", systemImage: "magnifyingglass")}
//                 .tag(MainTab.search)
//            
//            AppointmentsTabRouter(router: router)
//                 .tabItem { Label("bookings", systemImage: "calendar")}
//                 .tag(MainTab.appointments)
//                 .badge(5)
//            
//            MyProfileTabRouter(router: router)
//                 .tabItem { Label("profile", systemImage: "person") }
//                 .tag(MainTab.profile)
//        }
//        .environmentObject(router)
//        .onChange(of: router.selectedTab) { oldValue, newValue in
//            switch newValue {
//            case .feed: router.feedPath = .init()
//            case .inbox: router.inboxPath = .init()
//            case .search: router.searchPath = .init()
//            case .appointments: router.appointmentsPath = .init()
//            case .profile: router.profilePath = .init()
//            }
//        }
    }
}
