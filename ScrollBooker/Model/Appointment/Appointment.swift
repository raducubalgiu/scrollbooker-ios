//
//  Appointment.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import Foundation
import SwiftUICore

public struct Appointment: Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let startDate: Date
    public let endDate: Date
    public let channel: String
    public let status: AppointmentStatus
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

public enum AppointmentStatus: String, CaseIterable, Sendable, Codable {
    case confirmed
    case cancelled
    case finished
    case unknown
    
    init(raw: String) {
        self = AppointmentStatus(rawValue: raw.lowercased()) ?? .unknown
    }
    
    var title: String {
        switch self {
        case .confirmed: return String(localized: "appointment.status.confirmed")
        case .cancelled: return String(localized: "appointment.status.cancelled")
        case .finished: return String(localized: "appointment.status.finished")
        case .unknown: return String(localized: "appointment.status.confirmed")
        }
    }
    
    var color: Color {
        switch self {
        case .confirmed: return .green
        case .cancelled: return Color.errorSB
        case .finished: return .gray
        case .unknown: return .gray
        }
    }
}
