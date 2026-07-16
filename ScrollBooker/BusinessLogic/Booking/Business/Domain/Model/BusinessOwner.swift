//
//  BusinessOwner.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

struct BusinessOwner: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    let ratingsAverage: Float
    let ratingsCount: Int
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
