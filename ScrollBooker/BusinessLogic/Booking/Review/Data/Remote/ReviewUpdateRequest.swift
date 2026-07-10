//
//  ReviewUpdateRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

struct ReviewUpdateRequest: Encodable {
    let review: String
    let rating: Int
}
