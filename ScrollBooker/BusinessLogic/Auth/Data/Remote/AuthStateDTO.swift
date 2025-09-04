//
//  AuthStateDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct AuthStateDTO: Codable {
    let is_validated: Bool
    let registration_step: String?
}
