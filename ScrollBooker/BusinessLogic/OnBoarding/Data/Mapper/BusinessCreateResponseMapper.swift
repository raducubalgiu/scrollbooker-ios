//
//  BusinessCreateResponseMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

extension BusinessCreateResponse {
    init(dto: BusinessCreateResponseDTO) {
        self.businessId = dto.businessId
        self.businessTypeId = dto.businessTypeId
        self.onboardingState = AuthState(dto: dto.onboardingState)
    }
}
