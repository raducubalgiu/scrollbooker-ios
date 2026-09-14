//
//  RootRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct RootRouter: View {
    @Environment(SessionManager.self) private var session

    var body: some View {
        rootContent
            .environment(session)
    }
    
    @ViewBuilder
    private var rootContent: some View {
        if !session.isInitialized {
            SplashView()
                .task {
                    await session.bootstrap()
                }
        } else if !session.isAuthenticated {
            AuthRouter(startStep: nil)
        } else if let info = session.userInfo {
            if info.isValidated {
                MainRouter()
            } else {
                AuthRouter(startStep: info.registrationStep)
            }
        } else {
            SplashView()
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
