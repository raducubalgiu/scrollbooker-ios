//
//  AccountInfoDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

struct AccountInfoDTO: Decodable {
    let privatePhone: String?
    let privatePhoneVerified: Bool
    let email: String
    let emailVerified: Bool

    enum CodingKeys: String, CodingKey {
        case privatePhone = "private_phone"
        case privatePhoneVerified = "private_phone_verified"
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

struct PrivatePhoneVerificationResultDTO: Decodable {
    let privatePhone: String?
    let privatePhoneVerified: Bool

    enum CodingKeys: String, CodingKey {
        case privatePhone = "private_phone"
        case privatePhoneVerified = "private_phone_verified"
    }
}
