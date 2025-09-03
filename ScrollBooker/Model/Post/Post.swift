//
//  Post.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import Foundation

struct Post: Codable, Hashable, Identifiable {
    let id: Int
    let description: String?
    let user: UserMini
    let product: PostProduct?
    let userAction: UserPostActions
    let mediaFiles: [PostMediaFile]
    let counters: PostCounters
    let mentions: [UserMini]
    let hashtags: [Hashtag]
    let bookable: Bool
    let businessId: Int?
    let instantBooking: Bool
    let lastMinute: LastMinute
    let createdAt: String
}

struct PostProduct: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let duration: Int
    let price: Decimal
    let priceWithDiscount: Decimal
    let discount: Decimal
    let currency: PostProductCurrency
}

struct PostProductCurrency: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
}

struct UserPostActions: Codable, Hashable {
    let isLiked: Bool
    let isBookmarked: Bool
    let isReposted: Bool
}

struct PostMediaFile: Codable, Hashable, Identifiable {
    let id: Int
    let url: String
    let type: String
    let thumbnailUrl: String
    let duration: Double
    let postId: Int
    let orderIndex: Int
    
    var postURL: URL? { URL(string: url) }
    var postthumbnailURL: URL? { URL(string: thumbnailUrl) }
}

enum MediaType: String, Codable {
    case image
    case video
}

struct Hashtag: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let createdAt: String
    let updatedAt: String
}

struct PostCounters: Codable, Hashable {
    let commentCount: Int
    let likeCount: Int
    let bookmarkCount: Int
    let shareCount: Int
    let bookingsCount: Int
}

struct FixedSlot: Codable, Hashable {
    let startTime: String
    let endTime: String
    let isBooked: Bool
}

struct LastMinute: Codable, Hashable {
    let isLastMinute: Bool
    let lastMinuteEnd: String?
    let hasFixedSlots: Bool
    let fixedSlots: [FixedSlot]
}
