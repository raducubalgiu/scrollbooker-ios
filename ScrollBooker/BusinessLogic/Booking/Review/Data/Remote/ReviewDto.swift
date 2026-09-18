//
//  ReviewDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ReviewProductBusinessOwnerDto: Decodable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id, username, avatar
        case fullName = "fullname"
    }
}

struct ReviewCustomerDto: Decodable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id, username, avatar
        case fullName = "fullname"
    }
}

struct ReviewDto: Decodable {
    let id: Int
    let rating: Int
    let review: String
    let productBusinessOwner: ReviewProductBusinessOwnerDto
    let customer: ReviewCustomerDto
    let likeCount: Int
    let isLiked: Bool
    let isLikedByProductOwner: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, rating, review, customer
        case productBusinessOwner = "product_business_owner"
        case likeCount = "like_count"
        case isLiked = "is_liked"
        case isLikedByProductOwner = "is_liked_by_product_owner"
        case createdAt = "created_at"
    }
}
