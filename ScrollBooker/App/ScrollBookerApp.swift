//
//  ScrollBookerApp.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.08.2025.
//

import SwiftUI

@main
struct ScrollBookerApp: App {
    @UIApplicationDelegateAdaptor(AppBootstrapper.self) var appDelegate
    
    @StateObject private var theme = ThemeManager()
    @StateObject private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environmentObject(container)
                .environmentObject(container.session)
                .environmentObject(theme)
                .tint(.primarySB)
                .preferredColorScheme(theme.mode.prefferedColorScheme)
                .task {
                    await container.bootstrap()
                }
        }
    }
}

