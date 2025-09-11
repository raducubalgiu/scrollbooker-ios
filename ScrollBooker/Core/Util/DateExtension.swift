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
