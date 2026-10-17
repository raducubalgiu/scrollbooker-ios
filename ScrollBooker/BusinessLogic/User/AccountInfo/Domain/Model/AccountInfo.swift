//
//  AccountInfo.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

struct AccountInfo: Equatable, Hashable, Sendable {
    let privatePhone: String?
    let privatePhoneVerified: Bool
    let email: String
    let emailVerified: Bool
}

struct PrivatePhoneVerificationResult: Equatable, Hashable, Sendable {
    let privatePhone: String?
    let privatePhoneVerified: Bool
}
