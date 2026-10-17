//
//  GetPublicPhoneInfoUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

final class GetPublicPhoneInfoUseCase {
    private let repository: PublicPhoneRepository

    init(repository: PublicPhoneRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> PublicPhoneInfo {
        try await repository.getPublicPhoneInfo()
    }
}
