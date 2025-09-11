//
//  OnboardingRequestMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation

extension UpdateUsernameRequest {
    init(dto: UpdateUsernameRequestDTO) {
        self.username = dto.username
    }
}

extension UpdateBirthdateRequest {
    init(dto: UpdateBirthdateRequestDTO) {
        self.birthdate = dto.birthdate
    }
}

extension UpdateGenderRequest {
    init(dto: UpdateGenderRequestDTO) {
        self.gender = dto.gender
    }
}

extension UpdateBioRequest {
    init(dto: UpdateBioRequestDTO) {
        self.bio = dto.bio
    }
}

