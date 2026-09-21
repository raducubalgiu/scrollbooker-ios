//
//  RecentSearch.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

struct RecentSearch: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let businessDomainId: Int?
    let serviceDomain: RecentSearchServiceDomain
    let services: [RecentSearchService]
}

struct RecentSearchServiceDomain: Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct RecentSearchService: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let filters: [RecentSearchFilter]
}

struct RecentSearchFilter: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let subFilters: [RecentSearchSubFilter]
}

struct RecentSearchSubFilter: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

extension RecentSearch {
    var displayLabel: String? {
        guard let service = services.first else { return serviceDomain.name }

        let subFilterNames = service.filters.flatMap { $0.subFilters }.map { $0.name }

        if subFilterNames.isEmpty {
            return service.name
        } else {
            return "\(service.name) • \(subFilterNames.joined(separator: " & "))"
        }
    }
}
