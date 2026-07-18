//
//  ScheduleSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

enum WorkScheduleStatus {
    case full
    case short
    case closed
}

struct SchedulesSection: View {
    let schedules: [Schedule]
    
    var body: some View {
        let todayName = getTodayEnglishName()
        
        VStack(spacing: 0) {
            ForEach(schedules) { schedule in
                let isToday = schedule.dayOfWeek == todayName
                let scheduleStatus = getWorkScheduleStatus(startTime: schedule.startTime, endTime: schedule.endTime)
                
                let statusBg: Color = {
                    switch scheduleStatus {
                    case .closed: return Color(red: 0.8, green: 0.8, blue: 0.8)
                    case .short:  return Color(red: 0.98, green: 0.75, blue: 0.14)
                    case .full:   return Color.green
                    }
                }()
                
                let scheduleText: String = {
                    if let start = schedule.startTime, !start.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                       let end = schedule.endTime, !end.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        return "\(formatTime(start)) - \(formatTime(end))"
                    } else {
                        return String(localized: "closed")
                    }
                }()
                
                HStack(alignment: .center, spacing: 0) {
                    HStack(spacing: AppSize.base.rawValue) {
                        Circle()
                            .fill(statusBg)
                            .frame(width: 10, height: 10)
                        
                        Text(schedule.localizedDayOfWeek)
                            .font(.subheadline)
                            .fontWeight(isToday ? .bold : .regular)
                            .foregroundColor(.onBackgroundSB)
                    }
                    
                    Spacer()
                    
                    Text(scheduleText)
                        .font(.subheadline)
                        .fontWeight(isToday ? .bold : .regular)
                        .foregroundColor(.onBackgroundSB)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, .m)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func getWorkScheduleStatus(startTime: String?, endTime: String?) -> WorkScheduleStatus {
        guard let startTime = startTime, let endTime = endTime else { return .closed }
        
        let formatter = DateFormatter()
        formatter.dateFormat = startTime.count > 5 ? "HH:mm:ss" : "HH:mm"
        
        guard let startDate = formatter.date(from: startTime),
              let endDate = formatter.date(from: endTime) else {
            return .closed
        }
        
        let components = Calendar.current.dateComponents([.hour], from: startDate, to: endDate)
        let durationHours = components.hour ?? 0
        
        if durationHours >= 8 {
            return .full
        } else if durationHours >= 1 {
            return .short
        } else {
            return .closed
        }
    }
    
    private func getTodayEnglishName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date())
    }
    
    private func formatTime(_ timeStr: String) -> String {
        let clean = timeStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if clean.count > 5 {
            return String(clean.prefix(5))
        }
        return clean
    }
}
