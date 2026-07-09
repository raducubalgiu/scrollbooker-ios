//
//  AppointmentStatusEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import SwiftUICore

enum AppointmentStatusEnum: String, CaseIterable, Sendable, Codable {
    case inProgress = "in_progress"
    case canceled = "canceled"
    case finished = "finished"
    case unknown = "unknown"
    
    init(raw: String) {
        self = AppointmentStatusEnum(rawValue: raw.lowercased()) ?? .unknown
    }
    
    var title: String {
        switch self {
        case .inProgress: return String(localized: "appointment.status.confirmed")
        case .canceled: return String(localized: "appointment.status.cancelled")
        case .finished: return String(localized: "appointment.status.finished")
        case .unknown: return String(localized: "appointment.status.confirmed")
        }
    }
    
    var color: Color {
        switch self {
        case .inProgress: return .green
        case .canceled: return Color.errorSB
        case .finished: return .gray
        case .unknown: return .gray
        }
    }
}
