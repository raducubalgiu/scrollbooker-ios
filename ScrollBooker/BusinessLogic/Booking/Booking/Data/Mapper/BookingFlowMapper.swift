//
//  BookingFlowMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension BookingFlow {
    init(dto: BookingFlowDto) {
        self.business = BookingFlowBusiness(dto: dto.business)
        self.products = UserProducts(dto: dto.products)
        self.employees = dto.employees.map { BookingFlowUser(dto: $0) }
    }
}

extension BookingFlowBusiness {
    init(dto: BookingFlowBusinessDto) {
        self.owner = BookingFlowUser(dto: dto.owner)
        self.hasEmployees = dto.hasEmployees
        self.formattedAddress = dto.formattedAddress
    }
}

extension BookingFlowUser {
    init(dto: BookingFlowUserDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.profession = dto.profession
        self.avatar = dto.avatar
        self.ratingsCount = dto.ratingsCount
        self.ratingsAverage = Double(dto.ratingsAverage)
    }
}
