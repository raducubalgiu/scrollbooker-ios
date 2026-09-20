//
//  ReviewMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

extension Review {
    init(dto: ReviewDto) {
        self.id = dto.id
        self.rating = dto.rating
        self.review = dto.review
        self.productBusinessOwner = ReviewProductBusinessOwner(dto: dto.productBusinessOwner)
        self.customer = ReviewCustomer(dto: dto.customer)
        self.likeCount = dto.likeCount
        self.isLiked = dto.isLiked
        self.isLikedByProductOwner = dto.isLikedByProductOwner
        self.videoReview = dto.videoReview.map { ReviewVideoReview(dto: $0) }
        self.createdAt = dto.createdAt
    }
}

extension ReviewVideoReview {
    init(dto: ReviewVideoReviewDto) {
        self.id = dto.id
        self.mediaFiles = dto.mediaFiles.map { PostMediaFile(from: $0) }
    }
}

extension ReviewProductBusinessOwner {
    init(dto: ReviewProductBusinessOwnerDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.avatar = dto.avatar
    }
}

extension ReviewCustomer {
    init(dto: ReviewCustomerDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullName
        self.avatar = dto.avatar
    }
}

extension ReviewMutationResult {
    init(dto: ReviewMutationResponseDto) {
        self.id = dto.id
        self.review = dto.review
        self.rating = dto.rating
        self.customerId = dto.customerId
        self.userId = dto.userId
        self.appointmentId = dto.appointmentId
        self.parentId = dto.parentId
        self.createdAt = dto.createdAt
    }
}
