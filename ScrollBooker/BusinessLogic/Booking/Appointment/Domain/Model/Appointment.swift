//
//  Appointment.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import Foundation
import SwiftUICore

struct Appointment: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let startDate: Date
    let endDate: Date
    let channel: AppointmentChannelEnum
    let status: AppointmentStatusEnum
    let message: String?
    let isCustomer: Bool
    let products: [AppointmentProduct]
    let user: AppointmentUser
    let customer: AppointmentUser
    let business: AppointmentBusiness
    let totalPrice: Decimal
    let totalPriceWithDiscount: Decimal
    let totalDiscount: Decimal
    let totalDuration: Int
    let paymentCurrency: Currency
    let hasWrittenReview: Bool
    let hasVideoReview: Bool
    let writtenReview: AppointmentWrittenReview?
}

struct AppointmentWrittenReview: Codable, Hashable, Identifiable {
    let id: Int
    let review: String?
    let rating: Int
}

struct AppointmentProduct: Identifiable, Equatable, Hashable, Sendable {
    let id: Int?
    let name: String
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let duration: Int
    let currency: Currency
    let convertedPriceWithDiscount: Decimal
    let exchangeRate: Decimal?
}

struct AppointmentUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int?
    let fullName: String
    let username: String?
    let avatar: String?
    let profession: String?
    let ratingsAverage: Double?
    let ratingsCount: Int?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct AppointmentBusiness: Equatable, Hashable, Sendable {
    let address: String
    let coordinates: BusinessCoordinates
    let mapUrl: String?
}
