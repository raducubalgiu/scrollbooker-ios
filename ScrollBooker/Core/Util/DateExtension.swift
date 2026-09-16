//
//  DateExtension.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import Foundation

extension Date {
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro_RO")
        formatter.dateFormat = "LLLL"
        return formatter.string(from: self).capitalized
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    /// "Mar, 23 mai 2025 14:30" — aceeași compunere pe bucăți ca pe Android
    /// (`ZonedDateTime.display()`), nu un singur pattern, ca să putem controla
    /// separat capitalizarea zilei și eliminarea punctului final pe care
    /// abrevierile românești de zi/lună îl au uneori.
    func display(locale: Locale = Locale(identifier: "ro_RO")) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale

        formatter.dateFormat = "EEE"
        let dayOfWeek = formatter.string(from: self)
            .capitalized(with: locale)
            .removingTrailingDot()

        formatter.dateFormat = "d"
        let day = formatter.string(from: self).removingTrailingDot()

        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self)

        formatter.dateFormat = "MMM"
        let month = formatter.string(from: self)
            .lowercased(with: locale)
            .removingTrailingDot()

        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: self)

        return "\(dayOfWeek), \(day) \(month) \(year) \(time)"
    }
}

private extension String {
    func removingTrailingDot() -> String {
        hasSuffix(".") ? String(dropLast()) : self
    }
}

private let ymdFormatter: DateFormatter = {
    let f = DateFormatter()
    f.calendar = .init(identifier: .iso8601)
    f.locale = .init(identifier: "en_US_POSIX")
    f.timeZone = .init(secondsFromGMT: 0)
    f.dateFormat = "yyyy-MM-dd"
    return f
}()

private extension Date { var yyyyMMdd: String { ymdFormatter.string(from: self) } }
