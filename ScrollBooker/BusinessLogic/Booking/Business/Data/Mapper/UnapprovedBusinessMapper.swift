//
//  UnapprovedBusinessMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

extension UnapprovedBusiness {
    init(dto: UnapprovedBusinessDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.business = UnapprovedBusinessData(dto: dto.business)
    }
}

extension UnapprovedBusinessData {
    init(dto: UnapprovedBusinessDataDto) {
        self.id = dto.id
        self.hasEmployees = dto.hasEmployees
        self.location = UnapprovedLocation(dto: dto.location)
        self.businessType = UnapprovedBusinessType(dto: dto.businessType)
    }
}

extension UnapprovedLocation {
    init(dto: UnapprovedLocationDto) {
        self.coordinates = BusinessCoordinates(dto: dto.coordinates)
        self.address = dto.address
    }
}

extension UnapprovedBusinessType {
    init(dto: UnapprovedBusinessTypeDto) {
        self.id = dto.id
        self.name = dto.name
    }
}
