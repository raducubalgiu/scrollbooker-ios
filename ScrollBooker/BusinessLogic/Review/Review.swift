//
//  Review.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import Foundation
import SwiftUI

struct Review: Identifiable, Codable, Hashable {
    let id: Int
    let rating: Int
    let review: String
    let customer: ReviewCustomer
    let service: ReviewService
    let product: ReviewProduct
    let likeCount: Int
    let isLiked: Bool
    let isLikedByAuthor: Bool
    let createdAt: String
    
    var createdAtDate: Date? {
        ISO8601DateFormatter().date(from: createdAt)
    }
}

struct ReviewCustomer: Identifiable, Codable, Hashable {
    let id: Int
    let username: String
    let fullName: String
    let avatar:  String?
    
    var avatarURL: URL? {avatar.flatMap(URL.init(string:))}
}

struct ReviewService: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}

struct ReviewProduct: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
}
