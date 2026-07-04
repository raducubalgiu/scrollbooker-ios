//
//  SubfilterMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension SubFilter {
    init(dto: SubFilterDto) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
    }
}
