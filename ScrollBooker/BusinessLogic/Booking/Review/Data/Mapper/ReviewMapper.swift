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
        self.productBusinessOwner = ReviewProductBusinessOwner(dto: dto.product_business_owner)
        self.customer = ReviewCustomer(dto: dto.customer)
        self.service = ReviewService(dto: dto.service)
        self.product = dto.product.flatMap { ReviewProduct(dto: $0) }
        self.likeCount = dto.like_count
        self.isLiked = dto.is_liked
        self.isLikedByProductOwner = dto.is_liked_by_product_owner
        self.createdAt = dto.created_at
    }
}

extension ReviewProductBusinessOwner {
    init(dto: ReviewProductBusinessOwnerDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullname
        self.avatar = dto.avatar
    }
}

extension ReviewCustomer {
    init(dto: ReviewCustomerDto) {
        self.id = dto.id
        self.username = dto.username
        self.fullName = dto.fullname
        self.avatar = dto.avatar
    }
}

extension ReviewService {
    init(dto: ReviewServiceDto) {
        self.id = dto.id
        self.name = dto.name
    }
}

extension ReviewProduct {
    init(dto: ReviewProductDto) {
        self.id = dto.id
        self.name = dto.name
    }
}
