//
//  AccountInfoDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

struct AccountInfoDTO: Decodable {
    let phone: String?
    let phoneVerified: Bool
    let email: String
    let emailVerified: Bool

    enum CodingKeys: String, CodingKey {
        case phone
        case phoneVerified = "phone_verified"
        case email
        case emailVerified = "email_verified"
    }
}

struct PhoneVerificationSendRequestDTO: Encodable {
    let phone: String
}

struct PhoneVerificationCheckRequestDTO: Encodable {
    let phone: String
    let code: String
}

struct PhoneVerificationResultDTO: Decodable {
    let phone: String?
    let phoneVerified: Bool

    enum CodingKeys: String, CodingKey {
        case phone
        case phoneVerified = "phone_verified"
    }
}
