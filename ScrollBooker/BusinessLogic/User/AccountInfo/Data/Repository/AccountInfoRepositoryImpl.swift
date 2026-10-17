//
//  AccountInfoRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

final class AccountInfoRepositoryImpl: AccountInfoRepository {
    private let api: AccountInfoApiService

    init(api: AccountInfoApiService) {
        self.api = api
    }

    func getAccountInfo() async throws -> AccountInfo {
        let dto = try await api.getAccountInfo()
        return AccountInfo(dto: dto)
    }

    func sendPhoneVerificationCode(phone: String) async throws -> String {
        let dto = try await api.sendPhoneVerificationCode(request: PhoneVerificationSendRequestDTO(phone: phone))
        return dto.detail
    }

    func verifyPrivatePhoneNumber(phone: String, code: String) async throws -> PrivatePhoneVerificationResult {
        let dto = try await api.verifyPrivatePhoneNumber(request: PhoneVerificationCheckRequestDTO(phone: phone, code: code))
        return PrivatePhoneVerificationResult(dto: dto)
    }
}
