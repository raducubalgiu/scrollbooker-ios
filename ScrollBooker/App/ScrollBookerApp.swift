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
    @StateObject private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            AppTheme(mode: theme.mode) {
                RootRouter()
                    .environmentObject(container)
                    .environmentObject(container.session)
            }
            .environmentObject(theme)
        }
    }
}
