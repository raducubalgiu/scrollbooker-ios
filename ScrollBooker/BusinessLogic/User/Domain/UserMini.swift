//
//  UserMini.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 29.08.2025.
//

import Foundation
import SwiftUI

struct UserMini: Identifiable, Codable, Hashable {
    let id: Int
    let fullName: String
    let username: String
    let avatar: String?
    let isFollow: Bool
    let profession: String?
    let ratingsAverage: Double?
    let isBusinessOrEmployee: Bool
    
    var avatarURL: URL? { avatar.flatMap(URL.init(string:))}
}

extension UserMini {
    var usernameOrProfession: String {
        if !isBusinessOrEmployee {
            return "@\(username)"
        }
        return profession ?? "@\(username)"
    }
}
