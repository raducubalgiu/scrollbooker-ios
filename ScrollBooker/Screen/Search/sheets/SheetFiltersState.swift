//
//  SheetFiltersState.swift
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
        let currentSortRaw = sort ?? "recommended"
        return self.maxPrice != maxPrice ||
               self.sort.rawValue != currentSortRaw ||
               self.hasDiscount != hasDiscount
    }
    
    mutating func clear(defaultPrice: Decimal = 1500) {
        self.maxPrice = defaultPrice
        self.sort = .recommended
        self.hasDiscount = false
    }
}
