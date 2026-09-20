//
//  UpdatePostRequest.swift
//  ScrollBooker
//

struct UpdatePostRequest: Encodable {
    let description: String?
    let linkedProductIds: [Int]?
    let customCover: String?
    let serviceDomainId: Int?

    enum CodingKeys: String, CodingKey {
        case description
        case linkedProductIds = "linked_product_ids"
        case customCover = "custom_cover"
        case serviceDomainId = "service_domain_id"
    }
}
