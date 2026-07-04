//
//  BusinessMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Business {
    init(dto: BusinessDto) {
        self.id = dto.id
        self.businessTypeId = dto.business_type_id
        self.ownerId = dto.owner_id
        self.description = dto.description
        self.timezone = dto.timezone
        self.address = dto.address
        self.formattedAddress = dto.formatted_address

        self.coordinates = BusinessCoordinates(dto: dto.coordinates)
        
        self.city = dto.city
        self.countryCode = dto.country_code
        self.mapUrl = dto.map_url
        
        self.services = dto.services.map { Service(dto: $0) }
        self.schedules = dto.schedules.toDomain()
        
        self.hasEmployees = dto.has_employees
    }
}
