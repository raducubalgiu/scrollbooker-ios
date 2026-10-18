//
//  PublicPhoneRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

final class PublicPhoneRepositoryImpl: PublicPhoneRepository {
    private let api: PublicPhoneApiService

    init(api: PublicPhoneApiService) {
        self.api = api
    }

    func getPublicPhoneInfo() async throws -> PublicPhoneInfo {
        let dto = try await api.getPublicPhoneInfo()
        return PublicPhoneInfo(dto: dto)
    }

    func verifyPublicPhoneNumber(phone: String, code: String) async throws -> PublicPhoneUpdateResult {
        let dto = try await api.verifyPublicPhoneNumber(request: PhoneVerificationCheckRequestDTO(phone: phone, code: code))
        return PublicPhoneUpdateResult(dto: dto)
    }

    func useBusinessPublicPhone() async throws -> PublicPhoneUpdateResult {
        let dto = try await api.useBusinessPublicPhone()
        return PublicPhoneUpdateResult(dto: dto)
    }

    func updateContactPreference(_ preference: ContactPreferenceEnum) async throws -> ContactPreferenceEnum {
        let dto = try await api.updateContactPreference(request: ContactPreferenceUpdateRequestDTO(contactPreference: preference))
        return dto.contactPreference
    }
}
