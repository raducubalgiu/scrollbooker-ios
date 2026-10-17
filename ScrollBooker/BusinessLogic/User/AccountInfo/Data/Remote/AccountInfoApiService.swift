//
//  AccountInfoApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

protocol AccountInfoApiService: Sendable {
    func getAccountInfo() async throws -> AccountInfoDTO
    func sendPhoneVerificationCode(request: PhoneVerificationSendRequestDTO) async throws -> ActionMessageResponseDTO
    func verifyPrivatePhoneNumber(request: PhoneVerificationCheckRequestDTO) async throws -> PrivatePhoneVerificationResultDTO
}

final class AccountInfoAPIImpl: AccountInfoApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getAccountInfo() async throws -> AccountInfoDTO {
        try await client.request("users/user-info/account")
    }

    func sendPhoneVerificationCode(request: PhoneVerificationSendRequestDTO) async throws -> ActionMessageResponseDTO {
        try await client.request(
            "users/user-info/phone/send-verification",
            method: .post,
            body: request
        )
    }

    func verifyPrivatePhoneNumber(request: PhoneVerificationCheckRequestDTO) async throws -> PrivatePhoneVerificationResultDTO {
        try await client.request(
            "users/user-info/private-phone/verify",
            method: .post,
            body: request
        )
    }
}
