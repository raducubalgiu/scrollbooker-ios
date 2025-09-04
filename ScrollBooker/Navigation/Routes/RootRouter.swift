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
        rootContent
            .environmentObject(session)
    }
    
    @ViewBuilder
    private var rootContent: some View {
        if !app.isInitialized {
            SplashView()
                .task { await session.bootstrap() }
        } else if !app.isAuthenticated {
            AuthRouter(startStep: nil)
        } else {
            if let info = session.userInfo {
                if info.isValidated {
                    MainRouter()
                } else {
                    AuthRouter(startStep: info.registrationStep)
                }
            } else {
                SplashView()
                    .task { await session.bootstrap() }
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea();
            
            ProgressView().tint(.white)
        }
    }
}
