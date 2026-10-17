//
//  PublicPhoneVerificationViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation
import Observation
import OSLog

enum PublicPhoneVerificationStep {
    case enterPhone
    case enterCode
}

@Observable
@MainActor
final class PublicPhoneVerificationViewModel {
    private let sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase
    private let verifyPublicPhoneNumberUseCase: VerifyPublicPhoneNumberUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Settings")

    static let countryCode = "+40"

    var step: PublicPhoneVerificationStep = .enterPhone
    var localNumber: String = ""
    var code: String = ""
    var isSending = false
    var isVerifying = false
    var errorMessage: String?
    private(set) var verifiedResult: PublicPhoneUpdateResult?

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
        sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase,
        verifyPublicPhoneNumberUseCase: VerifyPublicPhoneNumberUseCase
    ) {
        self.sendPhoneVerificationCodeUseCase = sendPhoneVerificationCodeUseCase
        self.verifyPublicPhoneNumberUseCase = verifyPublicPhoneNumberUseCase
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
            errorMessage = logger.userMessage(for: error, context: "Sending Public Phone Verification Code")
            isSending = false
        }
    }

    @discardableResult
    func verifyCode() async -> Bool {
        guard isCodeComplete else { return false }

        isVerifying = true
        errorMessage = nil

        do {
            let result = try await withLoading {
                try await self.verifyPublicPhoneNumberUseCase(phone: self.fullPhone, code: self.code)
            }
            verifiedResult = result
            isVerifying = false
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Verifying Public Phone Number")
            isVerifying = false
            return false
        }
    }

    func backToPhoneStep() {
        step = .enterPhone
        code = ""
        errorMessage = nil
    }
}
