//
//  RegisterRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.09.2025.
//

import Foundation

struct RegisterRequestDTO: Codable {
    let email: String
    let password: String
    let role_name: String
}
