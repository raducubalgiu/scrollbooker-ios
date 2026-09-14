//
//  UserInfoRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

final class UserInfoRepositoryImpl: UserInfoRepository {
    private let api: UserInfoApiService

    init(api: UserInfoApiService) {
        self.api = api
    }

    func getUserInfo() async throws -> UserInfo {
        let dto = try await api.userInfo()
        return UserInfo(dto: dto)
    }
}
