//
//  Schedule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct Schedule: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let dayOfWeek: String
    let startTime: String?
    let endTime: String?
}
