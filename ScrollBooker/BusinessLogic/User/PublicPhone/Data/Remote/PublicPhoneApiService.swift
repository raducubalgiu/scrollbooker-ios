//
//  PublicPhoneApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

protocol PublicPhoneApiService: Sendable {
    func getPublicPhoneInfo() async throws -> PublicPhoneInfoDTO
    func verifyPublicPhoneNumber(request: PhoneVerificationCheckRequestDTO) async throws -> PublicPhoneUpdateResultDTO
    func useBusinessPublicPhone() async throws -> PublicPhoneUpdateResultDTO
}

final class PublicPhoneAPIImpl: PublicPhoneApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func getPublicPhoneInfo() async throws -> PublicPhoneInfoDTO {
        try await client.request("users/user-info/public-phone")
    }

    func verifyPublicPhoneNumber(request: PhoneVerificationCheckRequestDTO) async throws -> PublicPhoneUpdateResultDTO {
        try await client.request(
            "users/user-info/public-phone/verify",
            method: .post,
            body: request
        )
    }

    func useBusinessPublicPhone() async throws -> PublicPhoneUpdateResultDTO {
        try await client.request(
            "users/user-info/public-phone/use-business-number",
            method: .patch
        )
    }
}
