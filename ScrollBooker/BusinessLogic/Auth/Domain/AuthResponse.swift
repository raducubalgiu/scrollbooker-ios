//
//  AuthResponse.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
}
