//
//  AppointmentMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

extension Appointment {
    init(dto: AppointmentDto) throws {
        guard let start = dto.startDate.asISO8601Date() else {
            throw MappingError.invalidDate(dto.startDate)
        }

        guard let end = dto.endDate.asISO8601Date() else {
            throw MappingError.invalidDate(dto.endDate)
        }
        
        self.id = dto.id
        self.startDate = start
        self.endDate = end
        self.channel = AppointmentChannelEnum.fromKey(dto.channel) ?? .scrollBooker

        self.status = AppointmentStatusEnum(raw: dto.status)
        self.message = dto.message
        self.isCustomer = dto.isCustomer
        
        self.products = dto.products.map { AppointmentProduct(dto: $0) }
        
        self.user = AppointmentUser(dto: dto.user)
        self.customer = AppointmentUser(dto: dto.customer)
        self.business = AppointmentBusiness(dto: dto.business)
        
        self.totalPrice = dto.totalPrice
        self.totalPriceWithDiscount = dto.totalPriceWithDiscount
        self.totalDiscount = dto.totalDiscount
        self.totalDuration = dto.totalDuration
        self.paymentCurrency = Currency(dto: dto.paymentCurrency)
        
        self.hasWrittenReview = dto.hasWrittenReview
        self.hasVideoReview = dto.hasVideoReview
        self.writtenReview = dto.writtenReview.flatMap { AppointmentWrittenReview(dto: $0) }
    }
    
    func getProductNames() -> String {
            return products.map { $0.name }.joined(separator: ", ")
        }
    
    var formattedTotalDuration: String {
            let total = max(0, self.totalDuration)
            let hours = total / 60
            let minutes = total % 60
            
            if hours == 0 {
                return "\(minutes)min"
            } else {
                if minutes == 0 {
                    return "\(hours)h"
                } else {
                    return "\(hours)h \(minutes)min"
                }
            }
        }
}

extension AppointmentWrittenReview {
    init(dto: AppointmentWrittenReviewDto) {
        self.id = dto.id
        self.review = dto.review
        self.rating = dto.rating
        self.isEditable = dto.isEditable
        self.createdAt = dto.createdAt
    }
}

extension AppointmentProduct {
    init(dto: AppointmentProductDto) {
        self.id = dto.id
        self.productVariantId = dto.productVariantId
        self.offeringId = dto.offeringId
        self.name = dto.name
        self.price = dto.price
        self.priceWithDiscount = dto.priceWithDiscount
        self.discount = dto.discount
        self.duration = dto.duration
        self.currency = Currency(dto: dto.currency)
        self.convertedPriceWithDiscount = dto.convertedPriceWithDiscount
        self.exchangeRate = dto.exchangeRate
    }
}

extension AppointmentUser {
    init(dto: AppointmentUserDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.username = dto.username
        self.avatar = dto.avatar
        self.profession = dto.profession
        self.ratingsAverage = dto.ratingsAverage
        self.ratingsCount = dto.ratingsCount
    }
}

extension AppointmentBusiness {
    init(dto: AppointmentBusinessDto) {
        self.id = dto.id
        self.businessOwnerId = dto.businessOwnerId
        self.businessOwnerAvatar = dto.businessOwnerAvatar
        self.address = dto.address
        self.formattedAddress = dto.formattedAddress
        self.coordinates = BusinessCoordinates(dto: dto.coordinates)
        self.mapUrl = dto.mapUrl
        self.distanceKm = dto.distanceKm
    }
}
