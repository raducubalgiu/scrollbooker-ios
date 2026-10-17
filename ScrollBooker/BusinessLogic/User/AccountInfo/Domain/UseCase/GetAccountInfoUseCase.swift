//
//  GetAccountInfoUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

final class GetAccountInfoUseCase {
    private let repository: AccountInfoRepository

    init(repository: AccountInfoRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> AccountInfo {
        try await repository.getAccountInfo()
    }
}
