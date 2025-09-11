//
//  OnboardingRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation

struct UpdateUsernameRequest: Encodable {
    let username: String
}

struct UpdateBirthdateRequest: Encodable {
    let birthdate: String?
}

struct UpdateGenderRequest: Encodable {
    let gender: String
}

struct UpdateBioRequest: Encodable {
    let bio: String
}
