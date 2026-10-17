//
//  PublicPhoneViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class PublicPhoneViewModel {
    private let session: SessionManager
    private let getPublicPhoneInfoUseCase: GetPublicPhoneInfoUseCase
    private let useBusinessPublicPhoneUseCase: UseBusinessPublicPhoneUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Settings")

    var state: FeatureState<PublicPhoneInfo> = .idle
    var isSwitchingToBusinessNumber = false
    var switchError: String?

    var isEmployee: Bool {
        guard let userInfo = session.userInfo, let businessOwnerId = userInfo.businessOwnerId else {
            return false
        }
        return userInfo.id != businessOwnerId
    }

    init(
        session: SessionManager,
        getPublicPhoneInfoUseCase: GetPublicPhoneInfoUseCase,
        useBusinessPublicPhoneUseCase: UseBusinessPublicPhoneUseCase
    ) {
        self.session = session
        self.getPublicPhoneInfoUseCase = getPublicPhoneInfoUseCase
        self.useBusinessPublicPhoneUseCase = useBusinessPublicPhoneUseCase
    }

    func load() async {
        state = .loading
        do {
            let info = try await withLoading {
                try await self.getPublicPhoneInfoUseCase()
            }
            state = .success(info)
        } catch {
            state = .error(logger.userMessage(for: error, context: "Loading Public Phone Info"))
        }
    }

    func useBusinessNumber() async {
        guard case .success(let info) = state, !info.usesBusinessNumber else { return }

        isSwitchingToBusinessNumber = true
        switchError = nil

        do {
            let result = try await withLoading {
                try await self.useBusinessPublicPhoneUseCase()
            }
            state = .success(
                PublicPhoneInfo(
                    publicPhone: result.publicPhone,
                    publicPhoneVerified: result.publicPhoneVerified,
                    businessPublicPhone: info.businessPublicPhone,
                    businessPublicPhoneVerified: info.businessPublicPhoneVerified
                )
            )
        } catch {
            switchError = logger.userMessage(for: error, context: "Switching to Business Public Phone")
        }

        isSwitchingToBusinessNumber = false
    }

    func applyVerifiedPersonalNumber(_ result: PublicPhoneUpdateResult) {
        guard case .success(let info) = state else { return }

        state = .success(
            PublicPhoneInfo(
                publicPhone: result.publicPhone,
                publicPhoneVerified: result.publicPhoneVerified,
                businessPublicPhone: info.businessPublicPhone,
                businessPublicPhoneVerified: info.businessPublicPhoneVerified
            )
        )
    }
}
