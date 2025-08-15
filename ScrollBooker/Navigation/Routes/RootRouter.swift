//
//  RootRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct RootRouter: View {
    @EnvironmentObject private var app: AppState
    @StateObject private var session = SessionManager()
    
    var body: some View {
        Group {
            switch app.startDestination {
            case .splash:
                SplashView().task {
                    await session.bootstrap()
                }
            case .auth:
                MainRouter()
            case .main:
                MainRouter()
            }
        }
        .environmentObject(session)
    }
}

struct SplashView: View {
    var body: some View {
        ZStack { Color.black.ignoresSafeArea(); ProgressView().tint(.white) }
    }
}
