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
        let hours = ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"]
        list.append(contentsOf: hours.map { TimeOption(value: $0, name: $0) })
        return list
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                // Textul cu ziua săptămânii (Lățime fixă 90dp ca în Compose)
                Text(schedule.dayOfWeek)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(width: 90, alignment: .leading)
                
                // Cele două dropdown-uri (InputSelect în Compose)
                HStack(spacing: 16) {
                    // Dropdown Start Time
                    InputSelectView(
                        placeholder: String(localized: "closed"),
                        options: slots,
                        selectedOption: schedule.startTime ?? "null",
                        onValueChange: { newValue in
                            onChange(newValue, schedule.endTime)
                        }
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Dropdown End Time
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
            
            // Zona de eroare animată (Echivalent AnimatedVisibility)
            if isNotValid && showErrors {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "exclamationmark.triangle") // Icons.Outlined.Warning
                        .foregroundColor(.red) // Culoarea Error
                    
                    Text("Data de start nu poate fi mai mare decat data de sfarsit")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                .padding(.top, 16) // BasePadding
                .transition(.opacity.combined(with: .move(edge: .top))) // Animație fluidă la apariție
            }
        }
        .animation(.default, value: isNotValid && showErrors) // Activează animația în SwiftUI
    }
}
