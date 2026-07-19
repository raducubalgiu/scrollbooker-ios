//
//  SearchSortEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import Foundation

enum SearchSortEnum: String, CaseIterable, Identifiable {
    case recommended = "recommended"
    case distance = "distance"
    case rating = "rating"
    case price = "price"
    
    var id: Self { self }
    
    var label: String {
        switch self {
        case .recommended: return String(localized: "recommended")
        case .distance: return String(localized: "distance")
        case .rating: return String(localized: "rating")
        case .price: return String(localized: "price")
        }
    }
}
