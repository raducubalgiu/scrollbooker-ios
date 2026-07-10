//
//  SelectedServiceDomainWithServicesDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

struct SelectedServiceDomainsWithServicesDto: Codable {
    let id: Int
    let name: String
    let services: [SelectedServiceDto]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case services
    }
}

struct SelectedServiceDto: Codable {
    let id: Int
    let name: String
    let shortName: String
    let isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
        case isSelected = "is_selected"
    }
}

