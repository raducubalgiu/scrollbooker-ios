//
//  ServiceIdsUpdateRequestDTO.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

struct ServiceIdsUpdateRequestDTO: Encodable {
    let serviceIds: [Int]

    enum CodingKeys: String, CodingKey {
        case serviceIds = "service_ids"
    }
}
