//
//  LoginResponseDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct LoginResponseDTO: Codable {
    let access_token: String
    let refresh_token: String
    let token_type: String
}
