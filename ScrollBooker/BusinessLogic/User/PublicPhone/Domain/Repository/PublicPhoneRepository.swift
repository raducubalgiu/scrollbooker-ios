//
//  PublicPhoneRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

protocol PublicPhoneRepository: Sendable {
    func getPublicPhoneInfo() async throws -> PublicPhoneInfo
    func verifyPublicPhoneNumber(phone: String, code: String) async throws -> PublicPhoneUpdateResult
    func useBusinessPublicPhone() async throws -> PublicPhoneUpdateResult
    func updateContactPreference(_ preference: ContactPreferenceEnum) async throws -> ContactPreferenceEnum
}
