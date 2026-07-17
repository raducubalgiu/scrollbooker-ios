//
//  GetBusinessMarkersUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

final class GetBusinessesMarkersUseCase {
    private let repository: BusinessRepository

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    func callAsFunction(request: SearchBusinessRequest) async throws -> [BusinessMarker] {
        try await repository.getBusinessesMarkers(request: request)
    }
}
