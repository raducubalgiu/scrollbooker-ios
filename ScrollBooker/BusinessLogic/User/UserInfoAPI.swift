//
//  UserInfoAPI.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

protocol UserInfoAPI {
    func userInfo(bearer: String) async throws -> UserInfo
}

final class UserInfoAPIImpl: UserInfoAPI {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func userInfo(bearer: String) async throws -> UserInfo {
        let dto: UserInfoDTO = try await client.request("auth/user-info", bearer: bearer)
        
        return UserInfo(dto: dto)
    }
}
