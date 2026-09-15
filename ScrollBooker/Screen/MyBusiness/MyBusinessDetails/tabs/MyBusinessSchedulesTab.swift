//
//  MyBusinessSchedulesTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

// TODO: pasul 6 — program real (reutilizează MySchedulesSuccessView).
struct MyBusinessSchedulesTab: View {
    let viewModel: MyBusinessDetailsViewModel

    var body: some View {
        Text(String(localized: "scheduleShort"))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
