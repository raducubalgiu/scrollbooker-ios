//
//  UserSocial.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

struct UserSocial: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let profession: String
    let avatar: String?
    let ratingsAverage: Double
    let isFollow: Bool
    let isBusinessOrEmployee: Bool
}
