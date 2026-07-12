//
//  UpdateProfileFieldRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

struct UpdateFullNameRequest: Encodable {
    let fullname: String
}

struct UpdateUsernameRequest: Encodable {
    let username: String
}

struct UpdateBirthDateRequest: Encodable {
    let birthdate: String?
}

struct UpdateBioRequest: Encodable {
    let bio: String
}

struct UpdateGenderRequest: Encodable {
    let gender: String
}

struct UpdateWebsiteRequest: Encodable {
    let website: String
}

struct UpdatePublicEmailRequest: Encodable {
    let publicEmail: String
    
    enum CodingKeys: String, CodingKey {
        case publicEmail = "public_email"
    }
}
