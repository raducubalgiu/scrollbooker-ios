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
    @State private var networkMonitor = NetworkMonitor()
    @State private var toastCenter = ToastCenter()
    @State private var launchGate = AppLaunchGate()

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environment(container)
                .environment(container.session)
                .environment(theme)
                .environment(networkMonitor)
                .environment(toastCenter)
                .environment(launchGate)
                .overlay(alignment: .top) {
                    if !networkMonitor.isConnected {
                        NetworkStatusBanner()
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .overlay(alignment: .top) {
                    ToastOverlayView(toast: toastCenter.currentToast)
                }
                .animation(.easeInOut(duration: 0.25), value: networkMonitor.isConnected)
                .tint(.onBackgroundSB)
                .preferredColorScheme(theme.mode.prefferedColorScheme)
        }
    }
}

