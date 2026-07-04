//
//  ServiceDomainDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ServiceDomainDto: Codable {
    let id: Int
    let name: String
    let description: String?
    let url: String?
    let thumbnail_url: String?
}
