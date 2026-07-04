//
//  ServiceDomainMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension ServiceDomain {
    init(dto: ServiceDomainDto) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
        self.url = dto.url
        self.thumbnailUrl = dto.thumbnail_url
    }
}
