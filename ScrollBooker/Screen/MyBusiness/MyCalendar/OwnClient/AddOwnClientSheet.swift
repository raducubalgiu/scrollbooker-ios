//
//  AddOwnClientSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import Foundation

enum AddOwnClientSheet: Identifiable {
    case clientSelect
    case createClient
    case servicesSelect
    case dateTimeSelect

    var id: String {
        switch self {
            case .clientSelect: return "clientSelect"
            case .createClient: return "createClient"
            case .servicesSelect: return "servicesSelect"
            case .dateTimeSelect: return "dateTimeSelect"
        }
    }
}
