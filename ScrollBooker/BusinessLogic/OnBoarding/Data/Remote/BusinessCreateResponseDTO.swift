//
//  BusinessCreateResponseDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

struct BusinessCreateResponseDTO: Decodable {
    let businessId: Int
    let businessTypeId: Int
    let onboardingState: AuthStateDTO

    enum CodingKeys: String, CodingKey {
        case businessId = "business_id"
        case businessTypeId = "business_type_id"
        case onboardingState = "onboarding_state"
    }
}
