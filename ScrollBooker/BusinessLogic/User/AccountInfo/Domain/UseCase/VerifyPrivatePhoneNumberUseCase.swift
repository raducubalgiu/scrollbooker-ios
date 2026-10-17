//
//  VerifyPrivatePhoneNumberUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

final class VerifyPrivatePhoneNumberUseCase {
    private let repository: AccountInfoRepository

    init(repository: AccountInfoRepository) {
        self.repository = repository
    }

    func callAsFunction(phone: String, code: String) async throws -> PrivatePhoneVerificationResult {
        try await repository.verifyPrivatePhoneNumber(phone: phone, code: code)
    }
}
