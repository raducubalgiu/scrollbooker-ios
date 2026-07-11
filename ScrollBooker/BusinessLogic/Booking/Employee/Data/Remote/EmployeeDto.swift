//
//  EmployeeDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import Foundation

struct EmployeeDto: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "fullname"
        case avatar
        case job
        case hireDate = "hire_date"
        case ratingsAverage = "ratings_average"
        case followersCount = "followers_count"
        case ratingsCount = "ratings_count"
        case productsCount = "products_count"
    }
}
