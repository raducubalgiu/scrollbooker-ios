//
//  SearchUser.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct SearchUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Double
    let isBusinessOrEmployee: Bool
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
