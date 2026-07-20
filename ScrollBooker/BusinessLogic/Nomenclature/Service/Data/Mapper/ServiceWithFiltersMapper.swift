//
//  ServiceWithFiltersMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

extension ServiceWithFilters {
    init(dto: ServiceWithFiltersDto) {
        self.id = dto.id
        self.name = dto.name
        self.shortName = dto.shortName
        self.description = dto.description
        self.businessDomainId = dto.businessDomainId
        self.filters = dto.filters.map { Filter(dto: $0) }
    }
}
