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
    let bio: String?
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
}

struct BusinessOwner: Codable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let isFollow: Bool
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct UserCounters: Codable, Hashable, Sendable {
    let userId: Int
    let followingsCount: Int
    let followersCount: Int
    let productsCount: Int
    let postsCount: Int
    let ratingsCount: Int
    let ratingsAverage: Decimal
}

struct OpeningHours: Codable, Hashable, Sendable {
    let openNow: Bool
    let closingTime: String?
    let nextOpenDay: String?
    let nextOpenTime: String?
}

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
