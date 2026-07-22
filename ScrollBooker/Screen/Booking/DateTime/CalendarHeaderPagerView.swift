//
//  CalendarHeaderPagerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct CalendarHeaderPagerView: View {
    @Binding var currentWeekPage: Int
    let calendarDays: [Date]
    let availableDaysSet: Set<String>
    let selectedDay: Date
    var onChangeTab: (Int) -> Void
    
    private let totalWeeks = 26
    
    private static let isoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        TabView(selection: $currentWeekPage) {
            ForEach(0..<totalWeeks, id: \.self) { (page: Int) in
                let weekDates = Array(calendarDays.dropFirst(page * 7).prefix(7))
                
                HStack(spacing: 0) {
                    ForEach(0..<weekDates.count, id: \.self) { (index: Int) in
                        let date = weekDates[index]
                        let dateStr = Self.isoFormatter.string(from: date)
                        
                        let isAvailable = availableDaysSet.contains(dateStr)
                        let isSelected = Calendar.current.isDate(selectedDay, inSameDayAs: date)
                        let shortDayLabel = date.formatted(.dateTime.weekday(.short))
                        
                        VStack {
                            CalendarDayTabView(
                                date: date,
                                onChangeTab: {
                                    let targetDayIndex = (page * 7) + index
                                    onChangeTab(targetDayIndex)
                                },
                                isCurrentTab: isSelected,
                                isLoading: false,
                                isDayAvailable: isAvailable,
                                bgColor: isSelected ? Color.accentColor : Color.clear,
                                label: shortDayLabel
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .tag(page)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 95)
        .padding(.horizontal, .base)
    }
}

