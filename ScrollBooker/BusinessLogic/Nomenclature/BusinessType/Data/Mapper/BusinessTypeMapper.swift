//
//  BusinessTypeMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension BusinessType {
    init(dto: BusinessTypeDto, fallbackBusinessDomainId: Int? = nil) {
        self.id = dto.id
        self.name = dto.name
        self.plural = dto.plural
        self.businessDomainId = dto.businessDomainId ?? fallbackBusinessDomainId ?? 0
        self.url = dto.url
        self.thumbnailUrl = dto.thumbnailUrl
    }
}
