//
//  AppointmentsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AppointmentsScreen: View {
    @EnvironmentObject var router: Router
    
    @State private var items: [Int] = Array(1...20)
    @State private var isLoading = false
    
    @State private var showBottomSheet = false
    
    @State private var selected: AppointmentFilterTitleEnum = .all
    
    var onNavigateToAppointmentDetails: (Int) -> Void
    
    var body: some View {
        Header(
            title: String(localized: "bookings"),
            enableBack: false
        )
        
        Button {
            showBottomSheet = true
        } label: {
            Text("all")
                .font(.subheadline.bold())
                .foregroundColor(.onBackgroundSB)
            Image(systemName: "chevron.down")
                .foregroundColor(.onBackgroundSB)
        }
        .padding(.m)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.surfaceSB)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(appointmentsList) { item  in
                    AppointmentCardView(
                        appointment: item,
                        onClick: {
                            onNavigateToAppointmentDetails(item.id)
                        }
                    )
                    
                    Divider()
                }
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            AppointmentSheet(selected: $selected)
        }
    }
    
    private func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let next = (items.count + 1)...(items.count + 20)
            items.append(contentsOf: next)
            isLoading = false
        }
    }
}

#Preview("Light") {
    AppointmentsScreen(
        onNavigateToAppointmentDetails: {_ in }
    )
}

#Preview("Dark") {
    AppointmentsScreen(
        onNavigateToAppointmentDetails: {_ in }
    )
        .preferredColorScheme(.dark)
}
