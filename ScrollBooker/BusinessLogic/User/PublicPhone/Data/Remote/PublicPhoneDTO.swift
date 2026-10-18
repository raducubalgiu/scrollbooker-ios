//
//  PublicPhoneDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

struct PublicPhoneInfoDTO: Decodable {
    let publicPhone: String?
    let publicPhoneVerified: Bool
    let businessPublicPhone: String?
    let businessPublicPhoneVerified: Bool
    let contactPreference: ContactPreferenceEnum
    let businessContactPreference: ContactPreferenceEnum

    enum CodingKeys: String, CodingKey {
        case publicPhone = "public_phone"
        case publicPhoneVerified = "public_phone_verified"
        case businessPublicPhone = "business_public_phone"
        case businessPublicPhoneVerified = "business_public_phone_verified"
        case contactPreference = "contact_preference"
        case businessContactPreference = "business_contact_preference"
    }
}

struct PublicPhoneUpdateResultDTO: Decodable {
    let publicPhone: String?
    let publicPhoneVerified: Bool

    enum CodingKeys: String, CodingKey {
        case publicPhone = "public_phone"
        case publicPhoneVerified = "public_phone_verified"
    }
}

struct ContactPreferenceUpdateRequestDTO: Encodable {
    let contactPreference: ContactPreferenceEnum

    enum CodingKeys: String, CodingKey {
        case contactPreference = "contact_preference"
    }
}

struct ContactPreferenceResultDTO: Decodable {
    let contactPreference: ContactPreferenceEnum

    enum CodingKeys: String, CodingKey {
        case contactPreference = "contact_preference"
    }
}
