//
//  CalendarDayTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct CalendarDayTabView: View {
    let date: Date
    var onChangeTab: () -> Void
    let isCurrentTab: Bool
    let isLoading: Bool
    let isDayAvailable: Bool
    let bgColor: Color
    let label: String
    
    private var isPastDay: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDay = calendar.startOfDay(for: date)
        return targetDay < today
    }
    
    private var textDayColor: Color {
        if isLoading || isPastDay || !isDayAvailable {
            return Color.gray.opacity(0.4)
        } else if isCurrentTab {
            return Color.white
        } else {
            return .onBackgroundSB
        }
    }
    
    private var formattedDayNumber: String {
        let dayComponent = Calendar.current.component(.day, from: date)
        return String(dayComponent)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(isDayAvailable ? .onBackgroundSB : Color.gray.opacity(0.4))
                .lineLimit(1)
            
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 45, height: 45)
                
                Text(formattedDayNumber)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(textDayColor)
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            if isDayAvailable && !isPastDay && !isLoading {
                onChangeTab()
            }
        }
    }
}
