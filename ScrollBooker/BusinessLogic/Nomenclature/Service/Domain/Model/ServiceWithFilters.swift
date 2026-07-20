//
//  ServiceWithFilters.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

struct ServiceWithFilters: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let shortName: String
    let description: String?
    let businessDomainId: Int
    let filters: [Filter]
}
