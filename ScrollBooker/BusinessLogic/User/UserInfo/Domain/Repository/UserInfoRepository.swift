//
//  UserInfoRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

protocol UserInfoRepository: Sendable {
    func getUserInfo() async throws -> UserInfo
}
