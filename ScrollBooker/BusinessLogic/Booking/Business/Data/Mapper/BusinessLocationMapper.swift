//
//  BusinessLocationMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

extension BusinessLocation {
    init(dto: BusinessLocationDto) {
        self.address = dto.address
        self.formattedAddress = dto.formattedAddress
        self.city = dto.city
        self.coordinates = dto.coordinates
        self.mapUrl = dto.mapUrl
    }
}
