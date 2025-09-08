//
//  AppointmentDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

struct AppointmentDTO: Codable {
    let id: Int
    let start_date: String
    let end_date: String
    let channel: String
    let status: String
    let message: String?
    let product: AppointmentProductDTO
    let user: AppointmentUserDTO
    let is_customer: Bool
    let business: AppointmentBusinessDTO
}

struct AppointmentProductDTO: Codable {
    let id: Int?
    let name: String
    let price: Decimal
    let price_with_discount: Decimal
    let discount: Decimal
    let currency: String
    let exchangeRate: Decimal
}

struct AppointmentUserDTO: Codable {
    let id: Int?
    let avatar: String?
    let fullname: String
    let username: String?
    let profession: String?
}

struct BusinessCoordinatesDTO: Codable {
    let lat: Double
    let lng: Double
}

struct AppointmentBusinessDTO: Codable {
    let address: String
    let coordinates: BusinessCoordinatesDTO
}
