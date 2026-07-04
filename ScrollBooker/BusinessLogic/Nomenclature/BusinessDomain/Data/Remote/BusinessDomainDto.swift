//
//  BusinessDomainDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BusinessDomainDto: Codable {
    let id: Int
    let name: String
    let short_name: String
    let service_domains: [ServiceDomainDto]
    let business_types: [BusinessTypeDto]
    
    init(
        id: Int,
        name: String,
        short_name: String,
        service_domains: [ServiceDomainDto] = [],
        business_types: [BusinessTypeDto] = []
    ) {
        self.id = id
        self.name = name
        self.short_name = short_name
        self.service_domains = service_domains
        self.business_types = business_types
    }
}

