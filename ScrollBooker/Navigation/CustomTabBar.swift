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
            tabItem(title: "home", icon: "house", tab: .feed)
            tabItem(title: "inbox", icon: "bell", tab: .inbox, badge: 10)
            tabItem(title: "search", icon: "magnifyingglass", tab: .search)
            tabItem(title: "bookings", icon: "calendar", tab: .appointments, badge: 5)
            tabItem(title: "profile", icon: "person", tab: .profile)
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
    
    @ViewBuilder
    private func tabItem(
        title: String,
        icon: String,
        tab: MainTab,
        badge: Int? = nil
    ) -> some View {
        let isSelected = router.selectedTab == tab

        let iconName: String = {
            if isSelected {
                if icon == "magnifyingglass" || icon == "calendar" {
                    return icon
                }
                if icon == "calendar" {
                    return icon
                }
                return "\(icon).fill"
            }
            return icon
        }()
        
        Button {
            if isSelected {
                router.popToRoot()
            } else {
                router.selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: isSelected ? .bold : .regular))
                    .overlay(
                        Group {
                            if let badge = badge, badge > 0 {
                                Text("\(badge)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: -10)
                            }
                        }
                    )
                
                Text(title).font(.system(size: 10))
            }
            .foregroundColor(isSelected ? activeColor : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

