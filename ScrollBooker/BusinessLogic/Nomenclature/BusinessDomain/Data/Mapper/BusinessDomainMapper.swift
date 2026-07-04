//
//  BusinessDomainMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension BusinessDomain {
    init(dto: BusinessDomainDto) {
        self.id = dto.id
        self.name = dto.name
        self.shortName = dto.short_name
        
        self.serviceDomains = dto.service_domains.map { ServiceDomain(dto: $0) }
        self.businessTypes = dto.business_types.map { BusinessType(dto: $0) }
    }
}
