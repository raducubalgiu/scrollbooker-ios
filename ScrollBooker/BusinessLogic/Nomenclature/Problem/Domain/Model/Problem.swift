//
//  Problem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

struct Problem: Identifiable, Equatable, Hashable, Sendable, Codable {
    let id: Int
    let text: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case userId = "user_id"
    }
}
