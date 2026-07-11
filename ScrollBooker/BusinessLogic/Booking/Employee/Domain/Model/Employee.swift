//
//  Employee.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

struct Employee: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let username: String
    let fullName: String
    let avatar: String?
    let job: String
    let hireDate: String
    let ratingsAverage: Double
    let followersCount: Int
    let ratingsCount: Int
    let productsCount: Int
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
