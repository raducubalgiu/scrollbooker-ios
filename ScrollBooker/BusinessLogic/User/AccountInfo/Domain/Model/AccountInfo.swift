//
//  AccountInfo.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

struct AccountInfo: Equatable, Hashable, Sendable {
    let phone: String?
    let phoneVerified: Bool
    let email: String
    let emailVerified: Bool
}

struct PhoneVerificationResult: Equatable, Hashable, Sendable {
    let phone: String?
    let phoneVerified: Bool
}
