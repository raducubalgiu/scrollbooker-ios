//
//  BusinessMarker.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation
import CoreLocation

struct BusinessMarker: Identifiable, Equatable {
    let id: Int
    let owner: BusinessOwner
    let businessShortDomain: BusinessShortDomainEnum
    let address: String
    let coordinates: BusinessCoordinates
    let isPrimary: Bool
    let mediaFiles: [BusinessMediaFile?]
    
    var clCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lng)
    }
    
    static func == (lhs: BusinessMarker, rhs: BusinessMarker) -> Bool {
        lhs.id == rhs.id
    }
}
