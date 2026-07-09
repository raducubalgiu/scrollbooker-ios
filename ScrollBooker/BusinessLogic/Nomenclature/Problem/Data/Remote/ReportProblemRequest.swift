//
//  ReportProblemRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

struct ReportProblemRequest: Codable, Sendable {
    let text: String
    let user_id: Int
}
