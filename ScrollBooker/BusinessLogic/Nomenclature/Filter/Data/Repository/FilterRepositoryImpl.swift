//
//  FilterRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

final class FilterRepositoryImpl: FilterRepository {
    private let api: FilterApiService

    init(api: FilterApiService) {
        self.api = api
    }

    func getFiltersByService(serviceId: Int) async throws -> [Filter] {
        let dtos = try await api.getFiltersByService(serviceId: serviceId)
        return dtos.map { Filter(dto: $0) }
    }
}
