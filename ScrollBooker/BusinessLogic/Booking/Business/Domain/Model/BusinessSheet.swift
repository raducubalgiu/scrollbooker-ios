//
//  BusinessSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

struct BusinessSheet: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let owner: BusinessOwner
    let businessShortDomain: String
    let address: String
    let coordinates: BusinessCoordinates
    let hasVideo: Bool
    let mediaFiles: [BusinessMediaFile]
    let products: [Product]
    let distance: Float?
}
