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
    let customCover: String?
    let serviceDomainId: Int?

    enum CodingKeys: String, CodingKey {
        case description
        case provider
        case providerUid = "provider_uid"
        case orderIndex = "order_index"
        case linkedProductIds = "linked_product_ids"
        case customCover = "custom_cover"
        case serviceDomainId = "service_domain_id"
    }
}
