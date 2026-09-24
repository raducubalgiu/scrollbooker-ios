//
//  MyCalendarSlotContentView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarSlotContentView: View {
    let slot: CalendarEventsSlot
    let lineColor: Color
    let height: CGFloat
    let isBefore: Bool
    var isBlocking: Bool = false
    var showCheckbox: Bool = false
    var isChecked: Bool = false
    var isCheckboxEnabled: Bool = true

    private var isCompact: Bool { height < 40 }
    private var isVeryCompact: Bool { height < 28 }

    private var timeRangeText: String {
        guard let start = slot.startDate, let end = slot.endDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(timeRangeText)
                    .font(.footnote.bold())
                    .lineLimit(1)

                Spacer()

                if showCheckbox {
                    MyCalendarCheckmarkIndicatorView(checked: isChecked)
                        .opacity(isCheckboxEnabled ? 1 : 0.5)
                }
            }
            .frame(height: 40)

            if !isVeryCompact {
                Group {
                    if slot.isBlocked {
                        MyCalendarSlotMessageView(
                            text: slot.info?.blockedMessage ?? String(localized: "blocked"),
                            color: lineColor
                        )
                    } else if isChecked {
                        MyCalendarSlotMessageView(text: String(localized: "blockInProgress"), color: .errorSB)
                    } else if isBlocking && slot.isFreeSlot {
                        EmptyView()
                    } else if slot.isBooked {
                        MyCalendarSlotBookedView(slot: slot, maxLines: isCompact ? 1 : 2, showSubtitle: !isCompact)
                    } else if slot.isLastMinute {
                        MyCalendarSlotLastMinuteView(discount: slot.lastMinuteDiscount)
                    } else if isBefore {
                        MyCalendarSlotMessageView(text: String(localized: "unbookedSlot"), color: .gray)
                    } else {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                                .font(.system(size: min(max(height * 0.6, 16), 28)))
                                .foregroundColor(.dividerSB)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

private struct MyCalendarSlotMessageView: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(color)
            .lineLimit(2)
    }
}

private struct MyCalendarSlotBookedView: View {
    let slot: CalendarEventsSlot
    let maxLines: Int
    var showSubtitle: Bool = true

    private var title: String {
        slot.info?.customer?.fullname ?? String(localized: "booked")
    }

    private var subtitle: String {
        let servicesNames = slot.info?.products.map(\.productName).joined(separator: " • ") ?? ""
        let priceText: String? = slot.info.map { info in
            "\(String(format: "%.2f", NSDecimalNumber(decimal: info.totalPriceWithDiscount).doubleValue)) \(info.paymentCurrency.name)"
        }

        return [servicesNames.isEmpty ? nil : servicesNames, priceText]
            .compactMap { $0 }
            .joined(separator: " • ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.footnote.bold())
                .lineLimit(maxLines)

            if showSubtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(maxLines)
            }
        }
    }
}

private struct MyCalendarCheckmarkIndicatorView: View {
    let checked: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.gray.opacity(0.6), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(checked ? Color.errorSB : Color.clear)
                )
                .frame(width: 18, height: 18)

            if checked {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .allowsHitTesting(false)
    }
}

private struct MyCalendarSlotLastMinuteView: View {
    let discount: Decimal?

    var body: some View {
        Text("\(String(localized: "lastMinute")) • \(String(format: "%.0f", NSDecimalNumber(decimal: discount ?? 0).doubleValue))%")
            .font(.caption.bold())
            .foregroundColor(.ratingSB)
    }
}
