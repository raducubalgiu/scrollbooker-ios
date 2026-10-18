//
//  UpdateContactPreferenceUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

final class UpdateContactPreferenceUseCase {
    private let repository: PublicPhoneRepository

    init(repository: PublicPhoneRepository) {
        self.repository = repository
    }

    func callAsFunction(_ preference: ContactPreferenceEnum) async throws -> ContactPreferenceEnum {
        try await repository.updateContactPreference(preference)
    }
}
