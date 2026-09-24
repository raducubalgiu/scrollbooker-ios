//
//  RoleNameEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

enum RoleName: String, CaseIterable, Codable, Sendable {
    case business = "business"
    case superAdmin = "super_admin"
    case employee = "employee"
    case manager = "manager"
    case client = "client"
    
    static func fromKey(_ key: String) -> RoleName? {
        return RoleName(rawValue: key)
    }
}
