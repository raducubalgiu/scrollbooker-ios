//
//  ScrollBookerApp.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.08.2025.
//

import SwiftUI

@main
struct ScrollBookerApp: App {
    @StateObject private var theme = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            AppTheme(mode: theme.mode) {
                RootView()
            }
            .environmentObject(theme)
        }
    }
}
