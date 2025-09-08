//
//  AppointmentsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AppointmentsScreen: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel: AppointmentsViewModel
    var onNavigateToAppointmentDetails: (Int) -> Void
    
    init(
        viewModel: AppointmentsViewModel,
        onNavigateToAppointmentDetails: @escaping (Int) -> Void = { _ in }
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigateToAppointmentDetails = onNavigateToAppointmentDetails
    }
    
    @State private var showBottomSheet = false
    @State private var selected: AppointmentFilterTitleEnum = .all
    
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
        
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.appointments) { item  in
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
            .task { await viewModel.initialLoadIfNeeded() }
            .sheet(isPresented: $showBottomSheet) {
                AppointmentSheet(selected: $selected)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
    }
}

//#Preview("Light") {
//    AppointmentsScreen(
//        viewModel: AppointmentsViewModel(api: <#T##any AppointmentAPI#>, session: SessionManager),
//        onNavigateToAppointmentDetails: {_ in }
//    )
//}
//
//#Preview("Dark") {
//    AppointmentsScreen(
//        onNavigateToAppointmentDetails: {_ in }
//    )
//        .preferredColorScheme(.dark)
//}
