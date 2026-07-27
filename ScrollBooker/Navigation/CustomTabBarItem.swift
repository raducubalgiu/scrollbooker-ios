//
//  CustomTabBarItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.07.2026.
//

import SwiftUI

struct CustomTabBarItem: View {
    let title: String
    let icon: String
    let tab: MainTab
    let badge: Int?
    let activeColor: Color
    
    @Environment(Router.self) private var router
    
    private var isSelected: Bool {
        router.selectedTab == tab
    }
    
    private var iconName: String {
        if isSelected {
            if icon == "magnifyingglass" || icon == "calendar" {
                return icon
            }
            return "\(icon).fill"
        }
        return icon
    }
    
    var body: some View {
        Button {
            if isSelected {
                router.popToRoot()
            } else {
                router.selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: isSelected ? .bold : .semibold))
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
                
                Text(title)
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? activeColor : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}
