//
//  GetUserInfoUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

final class GetUserInfoUseCase {
    private let repository: UserInfoRepository

    init(repository: UserInfoRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> UserInfo {
        try await repository.getUserInfo()
    }
}
