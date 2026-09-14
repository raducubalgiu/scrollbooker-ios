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
    
    @State private var theme = ThemeManager()
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environment(container)
                .environment(container.session)
                .environment(theme)
                .tint(.onBackgroundSB)
                .preferredColorScheme(theme.mode.prefferedColorScheme)
                .task {
                    await container.bootstrap()
                }
        }
    }
}

