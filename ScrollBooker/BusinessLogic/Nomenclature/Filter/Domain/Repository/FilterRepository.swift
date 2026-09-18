//
//  FilterRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

protocol FilterRepository: Sendable {
    func getFiltersByService(serviceId: Int) async throws -> [Filter]
}
