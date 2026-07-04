//
//  AppointmentDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

struct CurrencyDto: Codable {
    let id: Int
    let name: String
}

struct AppointmentDto: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let channel: String
    let status: String
    let message: String?
    let isCustomer: Bool
    let products: [AppointmentProductDto]
    let user: AppointmentUserDto
    let customer: AppointmentUserDto
    let business: AppointmentBusinessDto
    let totalPrice: Decimal
    let totalPriceWithDiscount: Decimal
    let totalDiscount: Decimal
    let totalDuration: Int
    let paymentCurrency: CurrencyDto
    let hasWrittenReview: Bool
    let hasVideoReview: Bool
    let writtenReview: AppointmentWrittenReviewDto?
}

struct AppointmentWrittenReviewDto: Codable {
    let id: Int
    let review: String?
    let rating: Int
}

struct AppointmentProductDto: Codable {
    let id: Int?
    let name: String
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let duration: Int
    let currency: CurrencyDto
    let convertedPriceWithDiscount: Decimal
    let exchangeRate: Decimal?
}

struct AppointmentUserDto: Codable {
    let id: Int?
    let fullName: String
    let username: String?
    let avatar: String?
    let profession: String?
    let ratingsAverage: Double?
    let ratingsCount: Int?
}

struct AppointmentBusinessDto: Codable {
    let address: String
    let coordinates: BusinessCoordinatesDto
    let mapUrl: String?
}
