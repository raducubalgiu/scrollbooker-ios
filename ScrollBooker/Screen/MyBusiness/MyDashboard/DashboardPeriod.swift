//
//  DashboardPeriod.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct DashboardDateRange: Equatable {
    let startDate: Date
    let endDate: Date

    private static let apiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func format(pattern: String = "dd MMM") -> String {
        "\(startDate.asFormattedString(format: pattern)) - \(endDate.asFormattedString(format: pattern))"
    }

    func toApiStartDate() -> String {
        Self.apiFormatter.string(from: startDate)
    }

    func toApiEndDate() -> String {
        Self.apiFormatter.string(from: endDate)
    }
}

enum DashboardPeriod: CaseIterable, Equatable {
    case sevenDays
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear

    var title: String {
        switch self {
        case .sevenDays: return String(localized: "period_seven_days")
        case .oneMonth: return String(localized: "period_one_month")
        case .threeMonths: return String(localized: "period_three_months")
        case .sixMonths: return String(localized: "period_six_months")
        case .oneYear: return String(localized: "period_one_year")
        }
    }

    func getDateRange(referenceDate: Date = Date()) -> DashboardDateRange {
        let calendar = Calendar.current
        let endDate = referenceDate

        let startDate: Date = {
            switch self {
            case .sevenDays: return calendar.date(byAdding: .day, value: -7, to: referenceDate) ?? referenceDate
            case .oneMonth: return calendar.date(byAdding: .month, value: -1, to: referenceDate) ?? referenceDate
            case .threeMonths: return calendar.date(byAdding: .month, value: -3, to: referenceDate) ?? referenceDate
            case .sixMonths: return calendar.date(byAdding: .month, value: -6, to: referenceDate) ?? referenceDate
            case .oneYear: return calendar.date(byAdding: .year, value: -1, to: referenceDate) ?? referenceDate
            }
        }()

        return DashboardDateRange(startDate: startDate, endDate: endDate)
    }
}
