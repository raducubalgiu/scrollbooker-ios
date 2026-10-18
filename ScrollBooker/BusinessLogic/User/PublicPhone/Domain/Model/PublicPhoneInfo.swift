//
//  PublicPhoneInfo.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

struct PublicPhoneInfo: Equatable, Hashable, Sendable {
    let publicPhone: String?
    let publicPhoneVerified: Bool
    let businessPublicPhone: String?
    let businessPublicPhoneVerified: Bool
    let contactPreference: ContactPreferenceEnum
    let businessContactPreference: ContactPreferenceEnum

    var usesBusinessNumber: Bool {
        publicPhone == nil
    }
}

struct PublicPhoneUpdateResult: Equatable, Hashable, Sendable {
    let publicPhone: String?
    let publicPhoneVerified: Bool
}
