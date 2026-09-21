//
//  RecentSearchMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

extension RecentSearch {
    init(dto: RecentSearchDto) {
        self.id = dto.id
        self.businessDomainId = dto.businessDomainId
        self.serviceDomain = RecentSearchServiceDomain(dto: dto.serviceDomain)
        self.services = dto.services.map { RecentSearchService(dto: $0) }
    }
}

extension RecentSearchServiceDomain {
    init(dto: RecentSearchServiceDomainDto) {
        self.id = dto.id
        self.name = dto.name
    }
}

extension RecentSearchService {
    init(dto: RecentSearchServiceDto) {
        self.id = dto.id
        self.name = dto.name
        self.filters = dto.filters.map { RecentSearchFilter(dto: $0) }
    }
}

extension RecentSearchFilter {
    init(dto: RecentSearchFilterDto) {
        self.id = dto.id
        self.name = dto.name
        self.subFilters = dto.subFilters.map { RecentSearchSubFilter(dto: $0) }
    }
}

extension RecentSearchSubFilter {
    init(dto: RecentSearchSubFilterDto) {
        self.id = dto.id
        self.name = dto.name
    }
}
