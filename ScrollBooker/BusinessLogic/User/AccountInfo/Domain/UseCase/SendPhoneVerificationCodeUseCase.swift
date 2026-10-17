//
//  SendPhoneVerificationCodeUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

final class SendPhoneVerificationCodeUseCase {
    private let repository: AccountInfoRepository

    init(repository: AccountInfoRepository) {
        self.repository = repository
    }

    func callAsFunction(phone: String) async throws -> String {
        try await repository.sendPhoneVerificationCode(phone: phone)
    }
}
