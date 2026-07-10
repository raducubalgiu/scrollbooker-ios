//
//  CreateReviewRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

struct ReviewCreateRequest: Encodable {
    let review: String
    let rating: Int
    let user_id: Int
    let product_id: Int
    let parent_id: Int?
}
