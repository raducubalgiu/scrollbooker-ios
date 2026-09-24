//
//  DateExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

import Foundation

extension Date {
    func asFormattedString(
            format: String = "dd-MM-yyyy HH:mm",
            locale: Locale = Locale(identifier: "ro_RO")
        ) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = locale
            return formatter.string(from: self)
        }

    private static let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func asISODateString() -> String {
        Self.isoDateFormatter.string(from: self)
    }
}

extension String {
    private static let localDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    func asLocalDateTime() -> Date? {
        Self.localDateTimeFormatter.date(from: self)
    }
}
