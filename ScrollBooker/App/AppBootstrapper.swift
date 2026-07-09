//
//  AppBootstrapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import UIKit
import AVFoundation
import UIKit

final class AppBootstrapper: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        configureGlobalAppearance()
        configureAudioSession()
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
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Eroare la configurarea AVAudioSession: \(error.localizedDescription)")
        }
    }
}


