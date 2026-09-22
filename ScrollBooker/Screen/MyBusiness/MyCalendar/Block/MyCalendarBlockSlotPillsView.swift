//
//  MyCalendarBlockSlotPillsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarBlockSlotPillsView: View {
    let startDateLocaleValues: Set<String>

    private static let parseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private var sortedValues: [String] { startDateLocaleValues.sorted() }

    var body: some View {
        FlowLayout(horizontalSpacing: AppSize.xs.rawValue, verticalSpacing: AppSize.xs.rawValue) {
            ForEach(sortedValues, id: \.self) { raw in
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Text(timeLabel(for: raw))
                        .font(.footnote.bold())
                }
                .padding(.horizontal, .s)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.surfaceSB))
            }
        }
    }

    private func timeLabel(for raw: String) -> String {
        guard let date = Self.parseFormatter.date(from: raw) else { return raw }
        return Self.timeFormatter.string(from: date)
    }
}
