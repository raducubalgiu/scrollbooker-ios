//
//  UserProfileUpdateDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

struct UserProfileUpdateDto: Decodable {
    let id: Int
    let fullname: String
    let username: String
    let avatar: String?
    let bio: String?
    let dateOfBirth: String?
    let gender: String?
    let website: String?
    let publicEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case username
        case avatar
        case bio
        case dateOfBirth = "date_of_birth"
        case gender
        case website
        case publicEmail = "public_email"
    }
}
