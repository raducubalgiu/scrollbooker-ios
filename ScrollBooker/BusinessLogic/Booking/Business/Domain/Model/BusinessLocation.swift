//
//  BusinessLocation.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessLocation: Equatable, Hashable, Sendable {
    let address: String
    let formattedAddress: String?
    let city: String?
    let coordinates: BusinessCoordinates
    let mapUrl: String?
}
