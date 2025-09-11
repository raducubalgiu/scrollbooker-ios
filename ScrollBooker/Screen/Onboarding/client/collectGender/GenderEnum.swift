//
//  GenderType.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.09.2025.
//

import Foundation

enum GenderEnum: String, CaseIterable {
    case male = "male"
    case female = "female"
    case other = "other"
    
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}
