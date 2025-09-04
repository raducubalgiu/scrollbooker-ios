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
    let channel: String
    let status: AppointmentStatus
    let message: String?
    let product: AppointmentProduct
    let user: AppointmentUser
    let isCustomer: Bool
    let business: AppointmentBusiness
    
    var duration: TimeInterval { endDate.timeIntervalSince(startDate) }
}

struct AppointmentProduct: Equatable, Hashable, Sendable {
    let id: Int?
    let name: String
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let currency: String
    let exchangeRate: Decimal
}

struct AppointmentUser: Equatable, Hashable, Sendable {
    let id: Int?
    let avatar: String?
    let fullName: String
    let username: String?
    let profession: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

public struct BusinessCoordinates: Equatable, Hashable, Sendable {
    public let lat: Double
    public let lng: Double
}

struct AppointmentBusiness: Equatable, Hashable, Sendable {
    let address: String
    let coordinates: BusinessCoordinates
}

enum AppointmentStatus: String, CaseIterable, Sendable, Codable {
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
