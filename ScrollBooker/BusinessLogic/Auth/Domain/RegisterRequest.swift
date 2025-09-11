//
//  RegisterRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let roleName: String
}

