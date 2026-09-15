//
//  BusinessDetailsMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

extension BusinessDetails {
    init(dto: BusinessDetailsDto) {
        self.id = dto.id
        self.owner = BusinessOwner(dto: dto.owner)
        self.location = BusinessLocation(dto: dto.location)
        self.hasEmployees = dto.hasEmployees
        self.mediaFiles = dto.mediaFiles.map { BusinessMediaFile(dto: $0) }
        self.schedules = dto.schedules.toDomain()
    }
}
