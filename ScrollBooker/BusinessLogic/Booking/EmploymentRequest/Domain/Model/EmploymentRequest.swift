//
//  EmploymentRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct EmploymentRequest: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let createdAt: Date
    let status: String
    let employee: EmploymentRequestUser
    let employer: EmploymentRequestUser
    let profession: Profession
}

struct EmploymentRequestUser: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let profession: String
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }
}
