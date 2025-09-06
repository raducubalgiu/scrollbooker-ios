//
//  AppointmentSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import SwiftUI

struct AppointmentSheet: View {
    @Binding var selected: AppointmentFilterTitleEnum
    @State private var measuredHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("filterAppointments")
                .font(.headline)
                .padding(.vertical, 2)
            
            ForEach(Array(AppointmentFilterTitleEnum.allCases.enumerated()), id: \.element) { index, option in
                InputRadio(
                    title: option.localized,
                    isSelected: .constant(option == selected),
                    onClick: { selected = option }
                )
                
                if index < AppointmentFilterTitleEnum.allCases.count - 1 {
                    Divider()
                }
            }
            
            MainButton(
                title: String(localized: "filter"),
                onClick: {}
            )
        }
        .padding(.horizontal, .xl)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight + 16))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
    }
}

#Preview("Light") {
    @Previewable @State var selected: AppointmentFilterTitleEnum = .all
    
    AppointmentSheet(
        selected: $selected
    )
}

#Preview("Dark") {
    @Previewable @State var selected: AppointmentFilterTitleEnum = .all
    
    AppointmentSheet(
        selected: $selected
    )
        .preferredColorScheme(.dark)
}
