//
//  BusinessAddressMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

extension BusinessAddress {
    init(dto: BusinessAddressDto) {
        self.placeId = dto.placeId
        self.description = dto.description
    }
}
