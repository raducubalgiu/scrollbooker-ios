//
//  MyCalendarDayTimelineView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarDayTimelineView: View {
    let dayStartMinutes: Int
    let dayEndMinutes: Int
    let slots: [CalendarEventsSlot]
    let slotDuration: Int
    let domainColor: Color
    var isBlocking: Bool = false
    var pendingBlockSlots: Set<String> = []
    var onSlotTap: (CalendarEventsSlot) -> Void = { _ in }

    private var totalMinutes: Int { max(dayEndMinutes - dayStartMinutes, 0) }
    private var hourHeightValue: CGFloat { hourHeight(forSlotDurationMinutes: slotDuration) }
    private var dpPerMinute: CGFloat { hourHeightValue / 60 }
    private var contentHeight: CGFloat { dpPerMinute * CGFloat(totalMinutes) }

    private var ticks: [Int] {
        generateTicks(startMinutes: dayStartMinutes, endMinutes: dayEndMinutes, stepMinutes: slotDuration)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                MyCalendarTimeGutterView(
                    ticks: ticks,
                    dayStartMinutes: dayStartMinutes,
                    dpPerMinute: dpPerMinute,
                    height: contentHeight
                )

                ZStack(alignment: .topLeading) {
                    MyCalendarTimeGridView(
                        ticks: ticks,
                        dayStartMinutes: dayStartMinutes,
                        dpPerMinute: dpPerMinute,
                        height: contentHeight
                    )

                    ForEach(slots) { slot in
                        slotView(for: slot)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: contentHeight)
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private func slotView(for slot: CalendarEventsSlot) -> some View {
        if let slotStartMinutes = minutesFromDateTimeString(slot.startDateLocale),
           let slotEndMinutes = minutesFromDateTimeString(slot.endDateLocale) {
            let startMinute = max(0, slotStartMinutes - dayStartMinutes)
            let endMinute = min(totalMinutes, slotEndMinutes - dayStartMinutes)
            let durationMinutes = max(endMinute - startMinute, 0)

            if durationMinutes > 0 {
                let gap: CGFloat = 6
                let height = (dpPerMinute * CGFloat(durationMinutes)) - gap
                let offsetY = (dpPerMinute * CGFloat(startMinute)) + gap / 2
                let style = resolveSlotStyle(for: slot, domainColor: domainColor)

                let isLocallyStaged = pendingBlockSlots.contains(slot.startDateLocale)
                let isChecked = isLocallyStaged || slot.isBlocked
                let showCheckbox = (isBlocking && slot.isFreeSlot) || slot.isBlocked

                MyCalendarSlotView(
                    slot: slot,
                    style: style,
                    height: max(height, 0),
                    offsetY: offsetY,
                    isBlocking: isBlocking,
                    showCheckbox: showCheckbox,
                    isChecked: isChecked,
                    isCheckboxEnabled: !slot.isBlocked,
                    onCheckboxTap: { onSlotTap(slot) },
                    onTap: onSlotTap
                )
            }
        }
    }
}
