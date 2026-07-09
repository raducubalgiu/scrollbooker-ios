//
//  AppBootstrapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI
import UIKit

final class AppBootstrapper: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        configureGlobalAppearance()
        // Aici poți inițializa Firebase, Analytics, Crashlytics, etc.
        return true
    }
    
    private func configureGlobalAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(named: "Divider")
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

