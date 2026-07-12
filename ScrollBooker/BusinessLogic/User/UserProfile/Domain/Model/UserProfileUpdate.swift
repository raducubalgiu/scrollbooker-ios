//
//  UserProfileUpdate.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

struct UserProfileUpdate: Equatable, Hashable {
    let id: Int
    let fullName: String
    let username: String
    let avatarURL: String?
    let bio: String?
    let dateOfBirth: Date?
    let gender: String?
    let website: String?
    let publicEmail: String?
}
