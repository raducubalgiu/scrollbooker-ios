//
//  CustomTabBar.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

import SwiftUI

struct CustomTabBar: View {
    @Environment(Router.self) private var router
    @EnvironmentObject private var theme: ThemeManager
    
    let backgroundColor: Color
    
    private var activeColor: Color {
        backgroundColor == .black ? .white : .onBackgroundSB
    }
    
    private var dividerColor: Color {
        backgroundColor == .black ? Color.white.opacity(0.15) : .dividerSB
    }
    
    var body: some View {
        HStack {
            CustomTabBarItem(title: String(localized: "home"), icon: "house", tab: .feed, badge: nil, activeColor: activeColor)
            CustomTabBarItem(title: String(localized: "inbox"), icon: "bell", tab: .inbox, badge: 10, activeColor: activeColor)
            CustomTabBarItem(title: String(localized: "search"), icon: "magnifyingglass", tab: .search, badge: nil, activeColor: activeColor)
            CustomTabBarItem(title: String(localized: "bookings"), icon: "calendar", tab: .appointments, badge: 5, activeColor: activeColor)
            CustomTabBarItem(title: String(localized: "profile"), icon: "person", tab: .profile, badge: nil, activeColor: activeColor)
        }
        .padding(.top, 6)
        .frame(height: 49)
        .background(backgroundColor)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(dividerColor),
            alignment: .top
        )
    }
}


