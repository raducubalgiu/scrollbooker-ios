//
//  Filter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Filter: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let singleSelect: Bool
    let type: FilterTypeEnum?
    let subFilters: [SubFilter]
    let unit: String?
}
