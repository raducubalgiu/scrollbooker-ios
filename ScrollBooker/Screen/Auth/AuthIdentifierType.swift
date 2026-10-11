//
//  AuthIdentifierType.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

enum AuthIdentifierType: CaseIterable, Hashable {
    case email
    case username
    case phone

    var label: String {
        switch self {
        case .email: return String(localized: "auth_identifier_email")
        case .username: return String(localized: "auth_identifier_username")
        case .phone: return String(localized: "auth_identifier_phone")
        }
    }

    var placeholder: String {
        switch self {
        case .email: return String(localized: "email")
        case .username: return String(localized: "username")
        case .phone: return String(localized: "auth_identifier_phone_placeholder")
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .email: return .emailAddress
        case .username: return .default
        case .phone: return .phonePad
        }
    }
}
