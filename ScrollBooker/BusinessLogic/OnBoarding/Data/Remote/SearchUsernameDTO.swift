//
//  SearchUsernameDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation

struct SearchUsernameDTO: Codable {
    let available: Bool
    let suggestions: [String]
    let username: String?
}
