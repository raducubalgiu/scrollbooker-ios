//
//  FilterDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct FilterDto: Codable {
    let id: Int
    let name: String
    let single_select: Bool
    let sub_filters: [SubFilterDto]   
}
