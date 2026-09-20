//
//  CreateVideoReviewRequest.swift
//  ScrollBooker
//

struct CreateVideoReviewRequest: Encodable {
    let businessOrEmployeeId: Int
    let appointmentId: Int
    let review: String?
    let rating: Int
    let description: String?
    let provider: String
    let providerUid: String
    let orderIndex: Int
    let customCover: String?

    enum CodingKeys: String, CodingKey {
        case businessOrEmployeeId = "business_or_employee_id"
        case appointmentId = "appointment_id"
        case review
        case rating
        case description
        case provider
        case providerUid = "provider_uid"
        case orderIndex = "order_index"
        case customCover = "custom_cover"
    }
}
