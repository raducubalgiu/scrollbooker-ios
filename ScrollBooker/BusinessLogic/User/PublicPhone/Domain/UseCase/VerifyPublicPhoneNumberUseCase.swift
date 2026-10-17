//
//  VerifyPublicPhoneNumberUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

final class VerifyPublicPhoneNumberUseCase {
    private let repository: PublicPhoneRepository

    init(repository: PublicPhoneRepository) {
        self.repository = repository
    }

    func callAsFunction(phone: String, code: String) async throws -> PublicPhoneUpdateResult {
        try await repository.verifyPublicPhoneNumber(phone: phone, code: code)
    }
}
