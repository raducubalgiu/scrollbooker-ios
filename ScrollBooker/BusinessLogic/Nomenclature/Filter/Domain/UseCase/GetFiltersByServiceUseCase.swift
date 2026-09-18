//
//  GetFiltersByServiceUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class GetFiltersByServiceUseCase {
    private let repository: FilterRepository

    init(repository: FilterRepository) {
        self.repository = repository
    }

    func callAsFunction(serviceId: Int) async throws -> [Filter] {
        try await repository.getFiltersByService(serviceId: serviceId)
    }
}
