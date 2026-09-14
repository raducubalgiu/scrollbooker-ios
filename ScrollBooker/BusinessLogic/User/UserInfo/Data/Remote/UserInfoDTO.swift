//
//  UserInfoDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct UserInfoDTO: Codable {
    let id: Int
    let username: String
    let fullname: String
    let profession: String
    let avatar: String?
    let business_id: Int?
    let business_owner_id: Int?
    let business_type_id: Int?
    let has_employees: Bool
    let is_validated: Bool
    let registration_step: String?
}
