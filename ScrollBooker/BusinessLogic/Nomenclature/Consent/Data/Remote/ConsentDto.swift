//
//  ConsentDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct ConsentDto: Codable {
    let id: Int
    let name: String
    let title: String
    let text: String
    let version: String
    let created_at: String 
}
