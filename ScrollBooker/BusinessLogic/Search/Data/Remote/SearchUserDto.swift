//
//  SearchUserDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct SearchUserDto: Codable {
    let id: Int
    let username: String
    let fullname: String
    let avatar: String?
    let profession: String
    let ratings_average: Float
    let is_business_or_employee: Bool     
}
