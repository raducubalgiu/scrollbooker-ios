//
//  VerifyPhoneNumberUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

final class VerifyPhoneNumberUseCase {
    private let repository: AccountInfoRepository

    init(repository: AccountInfoRepository) {
        self.repository = repository
    }

    func callAsFunction(phone: String, code: String) async throws -> PhoneVerificationResult {
        try await repository.verifyPhoneNumber(phone: phone, code: code)
    }
}
