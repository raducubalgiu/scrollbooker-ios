//
//  AppointmentScrollBookerCreateRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import Foundation

struct AppointmentScrollBookerCreateRequest: Encodable {
    let startDate: String
    let endDate: String
    let productVariants: [AppointmentProductVariantCreateDto]
    let paymentCurrencyId: Int

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case productVariants = "product_variants"
        case paymentCurrencyId = "payment_currency_id"
    }
}

struct AppointmentProductVariantCreateDto: Encodable, Identifiable {
    let id: Int
    let offering: AppointmentProductOfferingCreateDto
}

struct AppointmentProductOfferingCreateDto: Encodable {
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
