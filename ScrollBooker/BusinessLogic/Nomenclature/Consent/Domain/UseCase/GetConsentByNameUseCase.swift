//
//  GetConsentByNameUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class GetConsentByNameUseCase {
    private let repository: ConsentRepository

    init(repository: ConsentRepository) {
        self.repository = repository
    }

    func callAsFunction(consentName: ConsentEnum) async throws -> Consent {
        try await repository.getConsentbyName(consentName: consentName)
    }
}
