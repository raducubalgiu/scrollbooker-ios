//
//  Appointment.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import Foundation

public struct Appointment: Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let startDate: Date
    public let endDate: Date
    public let channel: String
    public let status: String
    public let message: String?
    public let product: AppointmentProduct
    public let user: AppointmentUser
    public let isCustomer: Bool
    public let business: AppointmentBusiness
    
    public var duration: TimeInterval { endDate.timeIntervalSince(startDate) }
}

public struct AppointmentProduct: Equatable, Hashable, Sendable {
    public let id: Int?
    public let name: String
    public let price: Decimal
    public let priceWithDiscount: Decimal
    public let discount: Decimal
    public let currency: String
    public let exchangeRate: Decimal
}

public struct AppointmentUser: Equatable, Hashable, Sendable {
    public let id: Int?
    public let avatar: String?
    public let fullName: String
    public let username: String?
    public let profession: String?
    
    public var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

public struct BusinessCoordinates: Equatable, Hashable, Sendable {
    public let lat: Double
    public let lng: Double
}

public struct AppointmentBusiness: Equatable, Hashable, Sendable {
    public let address: String
    public let coordinates: BusinessCoordinates
}
