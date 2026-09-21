//
//  MyCalendarContentPagerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarContentPagerView: View {
    let calendarEventsState: FeatureState<CalendarEvents>
    let daySchedule: Schedule?
    let slotDuration: Int
    var isBlocking: Bool = false
    var pendingBlockSlots: Set<String> = []
    var onSlotTap: (CalendarEventsSlot) -> Void = { _ in }
    var onRetry: () -> Void

    var body: some View {
        switch calendarEventsState {
            case .idle, .loading:
                LoadingView()

            case .error(let message):
                ErrorView(message: message, retryAction: onRetry)

            case .success(let calendarEvents):
                let slots = calendarEvents.days.first?.slots ?? []
                let domainColor = BusinessShortDomainEnum(fromKeyOrUnknown: calendarEvents.businessShortDomain).domainColor

                let scheduleStartMinutes = parseTimeStringToMinutes(daySchedule?.startTime)
                let scheduleEndMinutes = parseTimeStringToMinutes(daySchedule?.endTime)
                let slotsStartMinutes = slots.compactMap { minutesFromDateTimeString($0.startDateLocale) }.min()
                let slotsEndMinutes = slots.compactMap { minutesFromDateTimeString($0.endDateLocale) }.max()

                let dayStartMinutes = [scheduleStartMinutes, slotsStartMinutes].compactMap { $0 }.min()
                let dayEndMinutes = [scheduleEndMinutes, slotsEndMinutes].compactMap { $0 }.max()

                if let dayStartMinutes, let dayEndMinutes, dayStartMinutes < dayEndMinutes {
                    MyCalendarDayTimelineView(
                        dayStartMinutes: dayStartMinutes,
                        dayEndMinutes: dayEndMinutes,
                        slots: slots,
                        slotDuration: slotDuration,
                        domainColor: domainColor,
                        isBlocking: isBlocking,
                        pendingBlockSlots: pendingBlockSlots,
                        onSlotTap: onSlotTap
                    )
                } else {
                    NoDataView(
                        title: String(localized: "myCalendar"),
                        message: String(localized: "message_empty_appointments"),
                        systemImage: "calendar"
                    )
                    .padding(.top, .xxl)
                }
        }
    }
}
