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
    @StateObject private var app = AppState.shared
    
    
    var body: some Scene {
        WindowGroup {
            AppTheme(mode: theme.mode) {
                RootRouter()
            }
            .environmentObject(app)
            .environmentObject(theme)
        }
    }
}
