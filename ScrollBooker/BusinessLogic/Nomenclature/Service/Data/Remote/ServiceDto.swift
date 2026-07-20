//
//  ServiceDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ServiceDto: Decodable {
    let id: Int
    let name: String
    let short_name: String
    let description: String?
    let business_domain_id: Int     
}
