//
//  AppointmentMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

extension Appointment {
    init(dto: AppointmentDTO) throws {
        guard let start = DateParser.parseISO8601UTC(dto.start_date) else {
            throw MappingError.invalidDate(dto.start_date)
        }
        
        guard let end = DateParser.parseISO8601UTC(dto.end_date) else {
            throw MappingError.invalidDate(dto.end_date)
        }
        
        self.id = dto.id
        self.startDate = start
        self.endDate = end
        self.channel = dto.channel
        self.status = AppointmentStatus(raw: dto.status)
        self.message = dto.message
        self.product = AppointmentProduct(dto: dto.product)
        self.user = AppointmentUser(dto: dto.user)
        self.isCustomer = dto.is_customer
        self.business = AppointmentBusiness(dto: dto.business)
    }
}


extension AppointmentProduct {
    init(dto: AppointmentProductDTO) {
        self.id = dto.id
        self.name = dto.name
        self.price = dto.price
        self.priceWithDiscount = dto.price_with_discount
        self.discount = dto.discount
        self.currency = dto.currency
        self.exchangeRate = dto.exchangeRate
    }
}

extension AppointmentUser {
    init(dto: AppointmentUserDTO) {
        self.id = dto.id
        self.avatar = dto.avatar
        self.fullName = dto.fullname
        self.username = dto.username
        self.profession = dto.profession
    }
}

extension BusinessCoordinates {
    init(dto: BusinessCoordinatesDTO) {
        self.lat = dto.lat
        self.lng = dto.lng
    }
}

extension AppointmentBusiness {
    init(dto: AppointmentBusinessDTO) {
        self.address = dto.address
        self.coordinates = BusinessCoordinates(dto: dto.coordinates)
    }
}
