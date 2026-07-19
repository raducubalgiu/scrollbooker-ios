//
//  BusinessTypeMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension BusinessType {
    init(dto: BusinessTypeDto) {
        self.id = dto.id
        self.name = dto.name
        self.plural = dto.plural
        self.url = dto.url
        self.thumbnailUrl = dto.thumbnail_url
    }
}
