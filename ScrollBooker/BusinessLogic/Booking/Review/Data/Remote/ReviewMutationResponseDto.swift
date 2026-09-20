//
//  ReviewMutationResponseDto.swift
//  ScrollBooker
//

struct ReviewMutationResponseDto: Decodable {
    let id: Int
    let review: String
    let rating: Int
    let customerId: Int
    let userId: Int
    let appointmentId: Int
    let parentId: Int?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, review, rating
        case customerId = "customer_id"
        case userId = "user_id"
        case appointmentId = "appointment_id"
        case parentId = "parent_id"
        case createdAt = "created_at"
    }
}
