//
//  AppointmentOwnClientCreateRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

struct AppointmentOwnClientCreateRequestDTO: Encodable {
    let startDate: String
    let endDate: String
    let userId: Int
    let businessClientId: Int
    let paymentCurrencyId: Int
    let productVariants: [AppointmentProductVariantCreateDto]

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case userId = "user_id"
        case businessClientId = "business_client_id"
        case paymentCurrencyId = "payment_currency_id"
        case productVariants = "product_variants"
    }
}
