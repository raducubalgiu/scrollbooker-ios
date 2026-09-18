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
    let likeCount: Int
    let isLiked: Bool
    let isLikedByProductOwner: Bool
    let videoReview: ReviewVideoReview?
    let createdAt: String
}

struct ReviewVideoReview: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let mediaFiles: [PostMediaFile]
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

extension Review {
    func copy(
        id: Int? = nil,
        rating: Int? = nil,
        review: String? = nil,
        productBusinessOwner: ReviewProductBusinessOwner? = nil,
        customer: ReviewCustomer? = nil,
        likeCount: Int? = nil,
        isLiked: Bool? = nil,
        isLikedByProductOwner: Bool? = nil,
        videoReview: ReviewVideoReview?? = nil,
        createdAt: String? = nil
    ) -> Review {
        Review(
            id: id ?? self.id,
            rating: rating ?? self.rating,
            review: review ?? self.review,
            productBusinessOwner: productBusinessOwner ?? self.productBusinessOwner,
            customer: customer ?? self.customer,
            likeCount: likeCount ?? self.likeCount,
            isLiked: isLiked ?? self.isLiked,
            isLikedByProductOwner: isLikedByProductOwner ?? self.isLikedByProductOwner,
            videoReview: videoReview ?? self.videoReview,
            createdAt: createdAt ?? self.createdAt
        )
    }
}
