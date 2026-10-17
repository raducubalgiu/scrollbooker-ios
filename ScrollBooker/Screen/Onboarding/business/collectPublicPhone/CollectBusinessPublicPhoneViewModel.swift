//
//  CollectBusinessPublicPhoneViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation
import Observation
import OSLog

enum CollectBusinessPublicPhoneStep {
    case enterPhone
    case enterCode
}

@Observable
@MainActor
final class CollectBusinessPublicPhoneViewModel {
    private let session: SessionManager
    private let sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase
    private let collectBusinessPublicPhoneUseCase: CollectBusinessPublicPhoneUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    static let countryCode = "+40"

    var step: CollectBusinessPublicPhoneStep = .enterPhone
    var localNumber: String = ""
    var code: String = ""
    var isSending = false
    var isSaving = false
    var errorMessage: String?

    var fullPhone: String {
        Self.countryCode + localNumber.filter(\.isNumber)
    }

    var isPhoneValid: Bool {
        localNumber.filter(\.isNumber).count >= 9
    }

    var isCodeComplete: Bool {
        code.count == 6
    }

    init(
        session: SessionManager,
        sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase,
        collectBusinessPublicPhoneUseCase: CollectBusinessPublicPhoneUseCase
    ) {
        self.session = session
        self.sendPhoneVerificationCodeUseCase = sendPhoneVerificationCodeUseCase
        self.collectBusinessPublicPhoneUseCase = collectBusinessPublicPhoneUseCase
    }

    func sendCode() async {
        guard isPhoneValid else { return }

        isSending = true
        errorMessage = nil

        do {
            _ = try await withLoading {
                try await self.sendPhoneVerificationCodeUseCase(phone: self.fullPhone)
            }
            isSending = false
            step = .enterCode
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Sending Business Public Phone Verification Code")
            isSending = false
        }
    }

    @discardableResult
    func collectBusinessPublicPhone() async -> Bool {
        guard isCodeComplete else { return false }

        isSaving = true
        errorMessage = nil

        do {
            let authState = try await withLoading {
                try await self.collectBusinessPublicPhoneUseCase(phone: self.fullPhone, code: self.code)
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Collecting Business Public Phone")
            isSaving = false
            return false
        }
    }

    func backToPhoneStep() {
        step = .enterPhone
        code = ""
        errorMessage = nil
    }
}
