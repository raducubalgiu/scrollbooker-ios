//
//  SearchFiltersSheetState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SearchFiltersSheetState {
    var maxPrice: Decimal?
    var sort: SearchSortEnum
    var hasDiscount: Bool
    
    func hasChangesComparedTo(maxPrice: Decimal?, sort: String?, hasDiscount: Bool) -> Bool {
        let currentSortRaw = sort ?? SearchSortEnum.recommended.rawValue
        return self.maxPrice != maxPrice ||
               self.sort.rawValue != currentSortRaw ||
               self.hasDiscount != hasDiscount
    }

    mutating func clear(defaultPrice: Decimal? = nil) {
        self.maxPrice = defaultPrice ?? self.maxPrice
        self.sort = .recommended
        self.hasDiscount = false
    }

    func applyOn(_ base: SearchFilters) -> SearchFilters {
        var updated = base
        updated.maxPrice = maxPrice
        updated.sort = sort.rawValue
        updated.hasDiscount = hasDiscount
        return updated
    }
}
