//
//  ScheduleRowView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct ScheduleRow: View {
    let schedule: Schedule
    let onChange: (_ start: String?, _ end: String?) -> Void
    let isNotValid: Bool
    let showErrors: Bool
    
    private var slots: [TimeOption] {
        var list = [TimeOption(value: "null", name: String(localized: "closed"))]
        
        var current = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: current) ?? current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        while current <= endDate {
            let timeString = formatter.string(from: current)
            list.append(TimeOption(value: timeString, name: timeString))
            
            guard let next = Calendar.current.date(byAdding: .minute, value: 30, to: current) else { break }
            current = next
            
            if Calendar.current.component(.day, from: current) != Calendar.current.component(.day, from: endDate) {
                break
            }
        }
        
        return list
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                Text(schedule.localizedDayOfWeek)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .frame(width: 90, alignment: .leading)
                
                HStack(spacing: 16) {
                    InputSelectView(
                        placeholder: String(localized: "closed"),
                        options: slots,
                        selectedOption: schedule.startTime ?? "null",
                        onValueChange: { newValue in
                            onChange(newValue, schedule.endTime)
                        }
                    )
                    .frame(maxWidth: .infinity)
                    
                    InputSelectView(
                        placeholder: String(localized: "closed"),
                        options: slots,
                        selectedOption: schedule.endTime ?? "null",
                        onValueChange: { newValue in
                            onChange(schedule.startTime, newValue)
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            
            if isNotValid && showErrors {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                        
                        Text("Data de start nu poate fi mai mare decat data de sfarsit")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    .padding(.top, .base)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isNotValid && showErrors)
    }
}
