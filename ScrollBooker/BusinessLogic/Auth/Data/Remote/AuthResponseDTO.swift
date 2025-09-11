//
//  AuthResponseDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

struct AuthResponseDTO: Codable {
    let access_token: String
    let refresh_token: String
    let token_type: String
}

