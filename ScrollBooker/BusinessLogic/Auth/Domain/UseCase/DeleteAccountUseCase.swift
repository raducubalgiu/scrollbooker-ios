//
//  DeleteAccountUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

final class DeleteAccountUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> String {
        try await repository.deleteAccount()
    }
}
