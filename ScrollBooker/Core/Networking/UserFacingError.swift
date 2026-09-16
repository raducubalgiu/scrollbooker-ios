//
//  UserFacingError.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation
import OSLog

extension Logger {
    /// Logs `error` at `.error` level (persisted, publicly readable via Console.app —
    /// interpolated values are marked `.public` so they aren't redacted to `<private>`
    /// outside Xcode's own debug console), and returns the message to show the user:
    /// the exact error description on Development/Staging, a generic localized
    /// message on Production.
    func userMessage(for error: Error, context: String) -> String {
        self.error("ERROR: on \(context, privacy: .public): \(error.localizedDescription, privacy: .public)")

        guard !AppEnvironment.isProduction else {
            return String(localized: "message_error_something_went_wrong")
        }

        return (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
    }
}
