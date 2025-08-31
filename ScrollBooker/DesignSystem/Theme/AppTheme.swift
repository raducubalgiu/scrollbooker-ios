//
//  AppTheme.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.08.2025.
//

import SwiftUI

struct AppTheme<Content: View>: View {
    let mode: ThemeMode
    @ViewBuilder var content: () -> Content
    
    init(mode: ThemeMode, @ViewBuilder content: @escaping () -> Content) {
        self.mode = mode
        self.content = content
        Self.configureTabBar()
    }
    
    var body: some View {
        content()
            .tint(.primarySB)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundSB)
            .applyPreferredColorScheme(mode)
    }
    
    private static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(named: "Divider")
        
//        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "OnBackgroundSBB")
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
//            .foregroundColor: UIColor(named: "OnBackgroundSBB") ?? <#default value#>
//        ]
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension View {
    func applyPreferredColorScheme(_ mode: ThemeMode) -> some View {
        Group {
            if let scheme = mode.prefferedColorScheme {
                self.preferredColorScheme(scheme)
            } else {
                self
            }
        }
    }
}
