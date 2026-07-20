//
//  DateTimeStep.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct DateTimeStep: View {
    var state: DateTimeState
    var onBack: () -> Void
    var onConfirm: (DateTimeState) -> Void
    
    @State private var localState: DateTimeState
    @State private var internalSelectedDate = Date()
    
    private let todayString: String
    private let tomorrowString: String
    
    init(
        state: DateTimeState,
        onBack: @escaping () -> Void,
        onConfirm: @escaping (DateTimeState) -> Void
    ) {
        self.state = state
        self.onBack = onBack
        self.onConfirm = onConfirm
        self._localState = State(initialValue: state)
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let now = Date()
        self.todayString = formatter.string(from: now)
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) ?? now
        self.tomorrowString = formatter.string(from: tomorrow)
        
        if let existingDateStr = state.startDate, let date = formatter.date(from: existingDateStr) {
            self._internalSelectedDate = State(initialValue: date)
        }
    }
    
    var isClearEnabled: Bool {
        localState.startDate != nil || localState.startTime != nil || localState.endTime != nil
    }
    
    var dateRange: ClosedRange<Date> {
        let today = Date()
        let maxDate = Calendar.current.date(byAdding: .month, value: 12, to: today) ?? today
        return today...maxDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button(action: onBack) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(10)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Dată și oră")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    ServicesDateTimeDaySuggestions(
                        isTodaySelected: localState.startDate == todayString,
                        isTomorrowSelected: localState.startDate == tomorrowString,
                        onTodayClick: {
                            localState.startDate = todayString
                            updateInternalDate(from: todayString)
                        },
                        onTomorrowClick: {
                            localState.startDate = tomorrowString
                            updateInternalDate(from: tomorrowString)
                        }
                    )
                    .padding(.horizontal)
                    
                    DatePicker(
                        "",
                        selection: $internalSelectedDate,
                        in: dateRange,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .accentColor(.red)
                    .padding(.horizontal)
                    .onChange(of: internalSelectedDate) { _, newValue in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        localState.startDate = formatter.string(from: newValue)
                    }
                    
                    Spacer().frame(height: 32)
                }
            }
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 0.55)
                
                SearchSheetActions(
                    onClear: {
                        localState.startDate = nil
                        localState.startTime = nil
                        localState.endTime = nil
                    },
                    onConfirm: {
                        onConfirm(localState)
                    },
                    isClearEnabled: isClearEnabled,
                    isConfirmEnabled: true,
                    displayIcon: false,
                    primaryActionText: "Confirmă"
                )
            }
        }
        .background(Color(.systemBackground))
    }
    
    private func updateInternalDate(from dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            internalSelectedDate = date
        }
    }
}

struct ServicesDateTimeDaySuggestions: View {
    let isTodaySelected: Bool
    let isTomorrowSelected: Bool
    var onTodayClick: () -> Void
    var onTomorrowClick: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTodayClick) {
                Text("Azi")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isTodaySelected ? Color.primarySB : Color(.systemGray6))
                    .foregroundColor(isTodaySelected ? .white : .primary)
                    .cornerRadius(12)
            }
            
            Button(action: onTomorrowClick) {
                Text("Mâine")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isTomorrowSelected ? Color.primarySB : Color(.systemGray6))
                    .foregroundColor(isTomorrowSelected ? .white : .primary)
                    .cornerRadius(12)
            }
        }
    }
}
