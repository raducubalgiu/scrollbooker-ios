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
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Rezervari")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
        }
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(appointmentsList) { item  in
                    AppointmentCard(
                        appointment: item,
                        onClick: { router.push(.appointmentDetails(id: 1)) }
                    )
                    
                    Divider()
                }
            }
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
    AppointmentsScreen()
}

#Preview("Dark") {
    AppointmentsScreen()
        .preferredColorScheme(.dark)
}
