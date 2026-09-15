//
//  GetMyBusinessDetailsUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class GetMyBusinessDetailsUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> BusinessDetails {
        try await repository.getMyBusinessDetails()
    }
}
