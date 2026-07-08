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
}
