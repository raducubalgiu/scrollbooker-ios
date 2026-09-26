//
//  AppBootstrapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import UIKit
import AVFoundation
import UIKit
import GoogleSignIn
final class AppBootstrapper: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        configureAudioSession()
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }

    // Belt-and-suspenders alongside Info.plist's UISupportedInterfaceOrientations: the app is
    // portrait-only everywhere (the video feed has no landscape layout at all), and since iOS 13
    // this delegate method is the actual authority — Info.plist only sets the initial/declared
    // baseline — so both need to agree or a stray landscape rotation can still slip through.
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        .portrait
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

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}



