//
//  AppEnvironment.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

/// Runtime environment, derived from the active `API_HOST` (not from `#if DEBUG`).
///
/// This matters because `Release` today is wired to `Staging.xcconfig`, not
/// `Production.xcconfig` (see the root CLAUDE.md's "Build configuration" gotcha) —
/// a compile-time `#if DEBUG` check would treat a staging Release build as
/// production. Checking the resolved host instead means this starts working
/// correctly the moment `Production.xcconfig` gets wired to a real build
/// configuration, with no further code changes.
enum AppEnvironment {
    private static let productionHost = "api.scrollbooker.com"

    static var isProduction: Bool {
        NetworkConfig.default.baseURL.host == productionHost
    }
}
