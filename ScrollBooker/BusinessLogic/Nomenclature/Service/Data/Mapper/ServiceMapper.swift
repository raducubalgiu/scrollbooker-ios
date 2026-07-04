//
//  ServiceMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Service {
    init(dto: ServiceDto) {
        self.id = dto.id
        self.name = dto.name
        self.shortName = dto.short_name
        self.description = dto.description
        self.businessDomainId = dto.business_domain_id
    }
}
