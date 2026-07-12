//
//  UserProfile.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import Foundation

struct UserProfile: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?
    let gender: String
    let dateOfBirth: String?
    let bio: String?
    let website: String?
    let publicEmail: String?
    let instagram: String?
    let tiktok: String?
    let businessId: Int?
    let businessTypeId: Int?
    let counters: UserCounters
    let profession: String
    let openingHours: OpeningHours
    let isFollow: Bool
    let businessOwner: BusinessOwner?
    let isOwnProfile: Bool
    let isBusinessOrEmployee: Bool
    let distanceKm: Double?
    let address: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
    
    func copy(
        fullName: String? = nil,
        username: String? = nil,
        gender: String? = nil,
        dateOfBirth: String? = nil,
        bio: String? = nil,
        isFollow: Bool? = nil
    ) -> UserProfile {
        UserProfile(
            id: self.id,
            username: username ?? self.username,
            fullName: fullName ?? self.fullName,
            avatar: self.avatar,
            gender: self.gender,
            dateOfBirth: self.dateOfBirth,
            bio: bio ?? self.bio,
            website: self.website,
            publicEmail: self.publicEmail,
            instagram: self.instagram,
            tiktok: self.tiktok,
            businessId: self.businessId,
            businessTypeId: self.businessTypeId,
            counters: self.counters,
            profession: self.profession,
            openingHours: self.openingHours,
            isFollow: isFollow ?? self.isFollow,
            businessOwner: self.businessOwner,
            isOwnProfile: self.isOwnProfile,
            isBusinessOrEmployee: self.isBusinessOrEmployee,
            distanceKm: self.distanceKm,
            address: self.address
        )
    }
}

struct BusinessOwner: Codable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct UserCounters: Codable, Hashable, Sendable {
    let userId: Int
    let followingsCount: Int
    let followersCount: Int
    let productsCount: Int
    let postsCount: Int
    let ratingsCount: Int
    let ratingsAverage: Float
}

struct OpeningHours: Codable, Hashable, Sendable {
    let openNow: Bool
    let closingTime: String?
    let nextOpenDay: String?
    let nextOpenTime: String?
}

// Extensions
extension OpeningHours {
    var formattedStatus: String {
        let daysMap: [String: String] = [
            "Monday": String(localized: "monday"),
            
        ]
        
        if openNow {
            if let closing = closingTime, !closing.isEmpty {
                return "\(String(localized: "closingAt")) \(closing)"
            } else {
                return String(localized: "opens")
            }
        } else {
            if let nextDay = nextOpenDay,
               let hour = nextOpenTime,
               !nextDay.isEmpty, !hour.isEmpty {
                let localizedDay = daysMap[nextDay] ?? nextDay
                return "\(String(localized: "opens")) \(localizedDay.lowercased()) \(String(localized: "at")) \(hour)"
            } else {
                return String(localized: "closed")
            }
        }
    }
}
