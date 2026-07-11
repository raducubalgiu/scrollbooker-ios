//
//  GetProfessionsByBusinessTypeUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

final class GetProfessionsByBusinessTypeUseCase {
    private let repository: ProfessionRepository

    init(repository: ProfessionRepository) {
        self.repository = repository
    }

    func callAsFunction(businessTypeId: Int) async throws -> [Profession] {
        try await repository.getProfessionsBybusinessType(businessTypeId: businessTypeId)
    }
}
