//
//  Business.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Business: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let businessTypeId: Int
    let ownerId: Int
    let description: String?
    let timezone: String
    let address: String
    let formattedAddress: String
    let coordinates: BusinessCoordinates
    let city: String
    let countryCode: String
    let mapUrl: String
    let services: [Service]
    let schedules: [Schedule]
    let hasEmployees: Bool
}
