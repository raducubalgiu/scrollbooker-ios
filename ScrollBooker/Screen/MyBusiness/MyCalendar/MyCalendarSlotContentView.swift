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

    private var isExternalBlock: Bool {
        slot.isBlocked && slot.info?.isExternal == true
    }

    private var showsAddIcon: Bool {
        !isVeryCompact
            && !slot.isBlocked
            && !isChecked
            && !(isBlocking && slot.isFreeSlot)
            && !slot.isBooked
            && !slot.isLastMinute
            && !isBefore
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 2) {
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
                            MyCalendarSlotBookedView(
                                slot: slot,
                                lineColor: lineColor,
                                maxLines: isCompact ? 1 : 2,
                                showSubtitle: !isCompact
                            )
                        } else if slot.isLastMinute {
                            MyCalendarSlotLastMinuteView(discount: slot.lastMinuteDiscount)
                        } else if isBefore {
                            MyCalendarSlotMessageView(text: String(localized: "unbookedSlot"), color: .gray)
                        } else {
                            EmptyView()
                        }
                    }
                }

                if slot.isBlocked, !isVeryCompact {
                    Spacer(minLength: 0)
                    if isExternalBlock {
                        MyCalendarSlotGoogleCalendarBadgeView()
                    } else {
                        MyCalendarSlotFooterLabelView(text: String(localized: "blockedSlotFooter"))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            if showCheckbox {
                VStack {
                    HStack {
                        Spacer()
                        MyCalendarCheckmarkIndicatorView(checked: isChecked)
                            .opacity(isCheckboxEnabled ? 1 : 0.5)
                    }
                    Spacer()
                }
            }

            if showsAddIcon {
                Image(systemName: "plus.circle")
                    .font(.system(size: min(max(height * 0.6, 16), 28)))
                    .foregroundColor(.dividerSB)
            }
        }
    }
}

private struct MyCalendarSlotMessageView: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.footnote.bold())
            .foregroundColor(color)
            .lineLimit(2)
    }
}

private struct MyCalendarSlotFooterLabelView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.gray)
            .lineLimit(1)
    }
}

private struct MyCalendarSlotBookedView: View {
    let slot: CalendarEventsSlot
    let lineColor: Color
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
                .foregroundColor(lineColor)
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

private struct MyCalendarSlotGoogleCalendarBadgeView: View {
    var body: some View {
        HStack(spacing: 4) {
            Image("logo_google")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)

            MyCalendarSlotFooterLabelView(text: String(localized: "fromGoogleCalendar"))
        }
    }
}

private struct MyCalendarSlotLastMinuteView: View {
    let discount: Decimal?

    var body: some View {
        Text("\(String(localized: "lastMinute")) • \(String(format: "%.0f", NSDecimalNumber(decimal: discount ?? 0).doubleValue))%")
            .font(.footnote.bold())
            .foregroundColor(.ratingSB)
    }
}
