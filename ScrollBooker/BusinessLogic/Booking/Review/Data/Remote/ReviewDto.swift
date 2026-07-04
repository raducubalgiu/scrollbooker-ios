//
//  ReviewDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ReviewProductBusinessOwnerDto: Codable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
}

struct ReviewCustomerDto: Codable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
}

struct ReviewServiceDto: Codable {
    let id: Int
    let name: String
}

struct ReviewProductDto: Codable {
    let id: Int
    let name: String
}

struct ReviewDto: Codable {
    let id: Int
    let rating: Int
    let review: String
    let product_business_owner: ReviewProductBusinessOwnerDto
    let customer: ReviewCustomerDto
    let service: ReviewServiceDto
    let product: ReviewProductDto?
    let like_count: Int
    let is_liked: Bool
    let is_liked_by_product_owner: Bool
    let created_at: String 
}
