//
//  MainRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MainRouter: View {
    @State private var router = Router()
    @EnvironmentObject private var session: SessionManager
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            FeedTabRouter(router: router)
                .tabItem { Label("home", systemImage: "house") }
                .tag(MainTab.feed)
            
            InboxTabRouter(router: router)
                 .tabItem { Label("inbox", systemImage: "bell") }
                 .tag(MainTab.inbox)
                 .badge(10)
            
            SearchTabRouter(router: router)
                 .tabItem { Label("search", systemImage: "magnifyingglass") }
                 .tag(MainTab.search)
            
            AppointmentsTabRouter(router: router)
                 .tabItem { Label("bookings", systemImage: "calendar") }
                 .tag(MainTab.appointments)
                 .badge(5)
            
            ProfileTabRouter(router: router)
                 .tabItem { Label("profile", systemImage: "person") }
                 .tag(MainTab.profile)
        }
        .environment(router)
        .onChange(of: router.selectedTab) { oldValue, newValue in
            if oldValue == newValue {
                router.popToRoot()
            }
        }
    }
}

