//
//  SlotItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct SlotItemView: View {
    let slot: Slot
    var onSelectSlot: (Slot) -> Void
    
    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()
    
    private static let backupFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private var formattedHour: String {
        guard let date = Self.iso8601Formatter.date(from: slot.startDateLocale) ??
                          Self.backupFormatter.date(from: slot.startDateLocale) else {
            let components = slot.startDateLocale.components(separatedBy: "T")
            if components.count > 1, let timePart = components.last?.prefix(5) {
                return String(timePart)
            }
            return slot.startDateLocale
        }
        
        return date.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }
    
    private var formattedDiscount: String {
        guard let discount = slot.lastMinuteDiscount else { return "" }
        return String(format: "-%.0f%%", NSDecimalNumber(decimal: discount).doubleValue)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(formattedHour)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)
            
            Spacer()
            
            if slot.isLastMinute {
                HStack(spacing: 6) {
                    Text("Last Minute")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(formattedDiscount)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.red)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.all, 18)
        .background(Color.surfaceSB)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.dividerSB, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .padding(.horizontal, .base)
        .onTapGesture {
            onSelectSlot(slot)
        }
    }
}

