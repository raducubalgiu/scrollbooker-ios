//
//  BusinessProfile.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import Foundation

struct BusinessProfile: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let owner: BusinessProfileOwner
    let openingHours: OpeningHours
    let mediaFiles: [BusinessMediaFile]
    let location: BusinessLocation
    let distanceKm: Float?
    let description: String?
    let employees: [BusinessProfileEmployee]
    let schedules: [Schedule]
    let reviews: BusinessProfileReviews
    let posts: [BusinessProfileLatestPost]
    let nearbyBusinesses: [NearbyBusiness]
    let userProducts: UserProducts
}

struct BusinessProfileLatestPost: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let businessId: Int
    let user: BusinessProfileLatestPostUser
    let viewsCount: Int
    let mediaFiles: [PostMediaFile]
}

struct BusinessProfileLatestPostUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
}

struct BusinessProfileOwner: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let counters: BusinessProfileCounters
    let isFollow: Bool
}

struct BusinessLocation: Equatable, Hashable, Sendable {
    let address: String
    let formattedAddress: String
    let coordinates: BusinessCoordinates
    let mapUrl: String?
}

struct BusinessProfileCounters: Equatable, Hashable, Sendable {
    let followersCount: Int
    let followingsCount: Int
    let ratingsAverage: Float
    let ratingsCount: Int
}

struct BusinessProfileEmployee: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float
}

struct BusinessProfileReviews: Equatable, Hashable, Sendable {
    let total: Int
    let data: [BusinessProfileReview]
}

struct BusinessProfileReview: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let review: String
    let rating: Int
    let reviewer: BusinessProfileReviewer
    let createdAt: String
}

struct BusinessProfileReviewer: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
}

struct NearbyBusinessOwner: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let counters: BusinessProfileCounters
}

struct NearbyBusiness: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let owner: NearbyBusinessOwner
    let mediaFiles: [BusinessMediaFile]
    let location: BusinessLocation
    let distanceKm: Float?
}
