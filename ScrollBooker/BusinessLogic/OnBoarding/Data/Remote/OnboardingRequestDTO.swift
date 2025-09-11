//
//  OnboardingRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation

struct UpdateUsernameRequestDTO: Encodable {
    let username: String
}

struct UpdateBirthdateRequestDTO: Encodable {
    let birthdate: String?
}

struct UpdateGenderRequestDTO: Encodable {
    let gender: String
}

struct UpdateBioRequestDTO: Encodable {
    let bio: String
}
