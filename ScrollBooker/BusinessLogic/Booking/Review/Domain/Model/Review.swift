//
//  Review.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Review: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let rating: Int
    let review: String
    let productBusinessOwner: ReviewProductBusinessOwner
    let customer: ReviewCustomer
    let service: ReviewService
    let product: ReviewProduct?
    let likeCount: Int
    let isLiked: Bool
    let isLikedByProductOwner: Bool
    let createdAt: String
}

struct ReviewProductBusinessOwner: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct ReviewCustomer: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}

struct ReviewService: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct ReviewProduct: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
}

extension Review {
    func copy(
        id: Int? = nil,
        rating: Int? = nil,
        review: String? = nil,
        productBusinessOwner: ReviewProductBusinessOwner? = nil,
        customer: ReviewCustomer? = nil,
        service: ReviewService? = nil,
        product: ReviewProduct?? = nil,
        likeCount: Int? = nil,
        isLiked: Bool? = nil,
        isLikedByProductOwner: Bool? = nil,
        createdAt: String? = nil
    ) -> Review {
        Review(
            id: id ?? self.id,
            rating: rating ?? self.rating,
            review: review ?? self.review,
            productBusinessOwner: productBusinessOwner ?? self.productBusinessOwner,
            customer: customer ?? self.customer,
            service: service ?? self.service,
            product: product ?? self.product,
            likeCount: likeCount ?? self.likeCount,
            isLiked: isLiked ?? self.isLiked,
            isLikedByProductOwner: isLikedByProductOwner ?? self.isLikedByProductOwner,
            createdAt: createdAt ?? self.createdAt
        )
    }
}
