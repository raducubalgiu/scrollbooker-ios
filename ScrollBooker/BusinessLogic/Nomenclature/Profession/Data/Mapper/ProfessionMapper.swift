//
//  ProfessionMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Profession {
    init(dto: ProfessionDto) {
        self.id = dto.id
        self.name = dto.name
        self.businessDomainId = dto.business_domain_id
    }
}
