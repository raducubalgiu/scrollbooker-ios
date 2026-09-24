//
//  RootRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct RootRouter: View {
    @Environment(AppContainer.self) private var container
    @Environment(SessionManager.self) private var session
    @Environment(AppLaunchGate.self) private var launchGate

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
            AuthRouter(startStep: nil, container: container, session: session)
        } else if let info = session.userInfo {
            if info.isValidated {
                ZStack {
                    MainRouter()

                    if !launchGate.isFeedReady {
                        SplashView()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: launchGate.isFeedReady)
                    }
                }
                .task {
                    launchGate.startWatchdogIfNeeded()
                }
            } else {
                AuthRouter(startStep: info.registrationStep, container: container, session: session)
            }
        } else {
            SplashView()
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("Brand/splash")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ProgressView()
                .tint(.white)
                .padding(.bottom, .xxl)
        }
    }
}
