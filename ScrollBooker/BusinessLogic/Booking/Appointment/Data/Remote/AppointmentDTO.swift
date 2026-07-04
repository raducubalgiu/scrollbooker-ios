//
//  AppointmentDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

struct AppointmentDto: Decodable {
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
    
    @LossyDecimal var totalPrice: Decimal
    @LossyDecimal var totalPriceWithDiscount: Decimal
    @LossyDecimal var totalDiscount: Decimal
    
    let totalDuration: Int
    let paymentCurrency: CurrencyDto
    let hasWrittenReview: Bool
    let hasVideoReview: Bool
    let writtenReview: AppointmentWrittenReviewDto?
    
    enum CodingKeys: String, CodingKey {
        case id
        case startDate = "start_date"
        case endDate = "end_date"
        case channel
        case status
        case message
        case isCustomer = "is_customer"
        case products
        case user
        case customer
        case business
        case totalPrice = "total_price"
        case totalPriceWithDiscount = "total_price_with_discount"
        case totalDiscount = "total_discount"
        case totalDuration = "total_duration"
        case paymentCurrency = "payment_currency"
        case hasWrittenReview = "has_written_review"
        case hasVideoReview = "has_video_review"
        case writtenReview = "written_review"
    }
}

struct AppointmentWrittenReviewDto: Decodable {
    let id: Int
    let review: String?
    let rating: Int
}

struct AppointmentProductDto: Decodable {
    let id: Int?
    let name: String
    
    @LossyDecimal var price: Decimal
    @LossyDecimal var priceWithDiscount: Decimal
    @LossyDecimal var discount: Decimal
    
    let duration: Int
    let currency: CurrencyDto
    
    @LossyDecimal var convertedPriceWithDiscount: Decimal
    @LossyOptionalDecimal var exchangeRate: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case priceWithDiscount = "price_with_discount"
        case discount
        case duration
        case currency
        case convertedPriceWithDiscount = "converted_price_with_discount"
        case exchangeRate = "exchange_rate"
    }
}


struct AppointmentUserDto: Decodable {
    let id: Int?
    let fullName: String
    let username: String?
    let avatar: String?
    let profession: String?
    let ratingsAverage: Double?
    let ratingsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case username
        case avatar
        case profession
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
    }
}

struct AppointmentBusinessDto: Decodable {
    let address: String
    let coordinates: BusinessCoordinatesDto
    let mapUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case coordinates
        case mapUrl = "map_url"
    }
}
