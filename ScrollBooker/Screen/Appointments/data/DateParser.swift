//
//  DateParser.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

enum MappingError: Error {
    case invalidDate(String)
}

enum DateParser {
    static func parseISO8601UTC(_ string: String) -> Date? {
        // cu fractiuni de secunda
        if let d = iso8601Fractional.date(from: string) { return d }
        // fara fractiuni de secunda
        return iso8601.date(from: string)
        
    }
    
    private static let iso8601Fractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()
    
    private static let iso8601: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()
}
