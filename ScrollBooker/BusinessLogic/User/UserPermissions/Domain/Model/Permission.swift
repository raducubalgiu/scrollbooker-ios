//
//  Permission.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct Permission: Codable, Hashable, Identifiable {
    var id: String { code }
    
    let code: String
}
