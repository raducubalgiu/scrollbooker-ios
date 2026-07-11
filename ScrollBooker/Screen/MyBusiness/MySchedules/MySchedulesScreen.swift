//
//  MySchedulesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MySchedulesScreen: View {
    @State private var schedules: [Schedule] = [
        Schedule(id: 1, dayOfWeek: "Luni", startTime: "09:00", endTime: "17:00"),
        Schedule(id: 2, dayOfWeek: "Marți", startTime: "null", endTime: "null"),
        Schedule(id: 3, dayOfWeek: "Miercuri", startTime: "10:00", endTime: "15:00")
    ]
    @State private var isSaving = false
    
    var body: some View {
        MySchedulesSectionView(
            schedules: $schedules,
            isSaving: isSaving,
            onUpdateRow: { updatedSchedule in
                if let index = schedules.firstIndex(where: { $0.id == updatedSchedule.id }) {
                    schedules[index] = updatedSchedule
                }
            },
            onHandleSave: {
                print("Se salvează datele...")
            },
            onBack: {
                print("Înapoi")
            }
        )
    }
}
