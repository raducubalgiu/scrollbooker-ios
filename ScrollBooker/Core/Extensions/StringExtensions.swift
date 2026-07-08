//
//  StringExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

import Foundation

extension String {
    func asISO8601Date() -> Date? {
        let formatterWithFractionalSeconds = ISO8601DateFormatter()
        formatterWithFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatterWithFractionalSeconds.date(from: self) {
            return date
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: self)
    }
}
