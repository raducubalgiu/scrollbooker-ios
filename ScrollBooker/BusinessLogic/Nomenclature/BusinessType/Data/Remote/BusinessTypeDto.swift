//
//  BusinessTypeDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BusinessTypeDto: Codable {
    let id: Int
    let name: String
    let plural: String
    let business_domain_id: Int
    let url: String?
    let thumbnail_url: String?     
}
