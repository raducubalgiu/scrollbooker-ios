//
//  GoogleCalendarAuthorizationProvider.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import UIKit
import GoogleSignIn

// The backend exchanges this code server-side (redirect_uri "postmessage") and persists the
// resulting tokens in calendar_connections, so this must stay the "Web application" OAuth
// client whose id/secret the backend also holds — not the app's own iOS client id. Same client
// scrollbooker-android's GoogleCalendarAuthorizationProvider.kt uses, since it's one Google
// Cloud project shared by both apps.
private let googleCalendarWebClientID = "596516500254-p64hb68ucv96j118frd8pa2ml9s3ksab.apps.googleusercontent.com"
private let googleCalendarScope = "https://www.googleapis.com/auth/calendar"

enum GoogleCalendarAuthorizationError: Error {
    case missingServerAuthCode
    case missingPresentingViewController
    case missingClientID
}

@MainActor
final class GoogleCalendarAuthorizationProvider {
    func requestServerAuthCode() async throws -> String {
        guard let presentingViewController = UIApplication.shared.keyWindowRootViewController else {
            throw GoogleCalendarAuthorizationError.missingPresentingViewController
        }

        guard let iosClientID = GIDSignIn.sharedInstance.configuration?.clientID
            ?? Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            throw GoogleCalendarAuthorizationError.missingClientID
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: iosClientID,
            serverClientID: googleCalendarWebClientID
        )

        let result: GIDSignInResult
        if let currentUser = GIDSignIn.sharedInstance.currentUser {
            result = try await currentUser.addScopes(
                [googleCalendarScope],
                presenting: presentingViewController
            )
        } else {
            result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: presentingViewController,
                hint: nil,
                additionalScopes: [googleCalendarScope]
            )
        }

        guard let serverAuthCode = result.serverAuthCode else {
            throw GoogleCalendarAuthorizationError.missingServerAuthCode
        }

        return serverAuthCode
    }
}
