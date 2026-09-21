//
//  BusinessCoordinates.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation
import CoreLocation

public struct BusinessCoordinates: Equatable, Hashable, Sendable, Encodable, Decodable {
    public let lat: Double
    public let lng: Double
}

public extension BusinessCoordinates {
    func distanceKm(to other: BusinessCoordinates) -> Double {
        let from = CLLocation(latitude: lat, longitude: lng)
        let to = CLLocation(latitude: other.lat, longitude: other.lng)
        return from.distance(from: to) / 1000
    }
}
