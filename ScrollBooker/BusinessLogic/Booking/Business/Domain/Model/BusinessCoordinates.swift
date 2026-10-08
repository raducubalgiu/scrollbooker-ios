//
//  BusinessCoordinates.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

public struct BusinessCoordinates: Equatable, Hashable, Sendable, Encodable, Decodable {
    public let lat: Double
    public let lng: Double
}

extension BusinessCoordinates {
    private static let earthRadiusKm = 6371.0

    func distanceKm(to other: BusinessCoordinates) -> Double {
        func toRad(_ deg: Double) -> Double { deg * .pi / 180 }

        let dLat = toRad(other.lat - lat)
        let dLng = toRad(other.lng - lng)
        let lat1 = toRad(lat)
        let lat2 = toRad(other.lat)

        let a = pow(sin(dLat / 2), 2)
            + cos(lat1) * cos(lat2) * pow(sin(dLng / 2), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return Self.earthRadiusKm * c
    }
}
