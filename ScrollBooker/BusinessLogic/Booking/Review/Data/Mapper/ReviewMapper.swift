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
        self.createdAt = dto.createdAt
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
