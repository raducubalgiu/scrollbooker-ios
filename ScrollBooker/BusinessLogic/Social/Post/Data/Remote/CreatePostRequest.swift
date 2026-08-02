//
//  CreatePostRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

struct CreatePostRequest: Encodable {
    let description: String?
    let provider: String
    let providerUid: String
    let orderIndex: Int
    let linkedProductIds: [Int]
    let videoReviewMessage: String?
    let isVideoReview: Bool
    let rating: Int?
    let businessOrEmployeeId: Int?

    enum CodingKeys: String, CodingKey {
        case description
        case provider
        case providerUid = "provider_uid"
        case orderIndex = "order_index"
        case linkedProductIds = "linked_product_ids"
        case videoReviewMessage = "video_review_message"
        case isVideoReview = "is_video_review"
        case rating
        case businessOrEmployeeId = "business_or_employee_id"
    }
}
