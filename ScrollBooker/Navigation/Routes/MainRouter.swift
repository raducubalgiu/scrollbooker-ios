//
//  MainRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MainRouter: View {
    @StateObject private var router = Router()
    @EnvironmentObject private var session: SessionManager
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
           FeedTabRouter(router: router)
                .tabItem { Label("Feed", systemImage: "house") }
                .tag(MainTab.feed)
            
            InboxTabRouter(router: router)
                 .tabItem { Label("Inbox", systemImage: "bell") }
                 .tag(MainTab.inbox)
                 .badge(10)
            
            SearchTabRouter(router: router)
                 .tabItem { Label("Search", systemImage: "magnifyingglass")}
                 .tag(MainTab.search)
            
            AppointmentsTabRouter(router: router)
                 .tabItem { Label("Appointments", systemImage: "calendar")}
                 .tag(MainTab.appointments)
                 .badge(5)
            
            MyProfileTabRouter(router: router)
                 .tabItem { Label("Profile", systemImage: "person") }
                 .tag(MainTab.profile)
        }
        .environmentObject(router)
        .onChange(of: router.selectedTab) { oldValue, newValue in
            switch newValue {
            case .feed: router.feedPath = .init()
            case .inbox: router.inboxPath = .init()
            case .search: router.searchPath = .init()
            case .appointments: router.appointmentsPath = .init()
            case .profile: router.profilePath = .init()
            }
        }
    }
}
