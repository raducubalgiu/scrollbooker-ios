//
//  ConsentMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Consent {
    init(dto: ConsentDto) {
        self.id = dto.id
        self.name = dto.name
        self.title = dto.title
        self.text = dto.text
        self.version = dto.version
        self.createdAt = dto.created_at
    }
}
