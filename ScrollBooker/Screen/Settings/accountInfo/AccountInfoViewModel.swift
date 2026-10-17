//
//  AccountInfoViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class AccountInfoViewModel {
    private let getAccountInfoUseCase: GetAccountInfoUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Settings")

    var state: FeatureState<AccountInfo> = .idle

    init(getAccountInfoUseCase: GetAccountInfoUseCase) {
        self.getAccountInfoUseCase = getAccountInfoUseCase
    }

    func load() async {
        state = .loading
        do {
            let info = try await withLoading {
                try await self.getAccountInfoUseCase()
            }
            state = .success(info)
        } catch {
            state = .error(logger.userMessage(for: error, context: "Loading Account Info"))
        }
    }
}
