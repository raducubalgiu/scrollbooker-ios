//
//  AppointmentFilterTitleEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

enum AppointmentFilterTitleEnum: String, CaseIterable {
    case all = "all"
    case employee = "asEmployee"
    case client = "asClient"
    
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}
