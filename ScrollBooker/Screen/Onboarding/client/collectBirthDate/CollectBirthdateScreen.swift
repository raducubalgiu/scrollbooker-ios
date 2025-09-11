//
//  CollectClientBirthdateScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectBirthdateScreen: View {
    @EnvironmentObject private var session: SessionManager
    @State var viewModel: CollectBirthdateViewModel
    
    @State private var date = Date()
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? .distantPast
        let end = Date()
        return start...end
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "dateOfBirth"),
            subHeadline: String(localized: "dateOfBirthLabelDescription"),
            buttonTitle: String(localized: "nextStep"),
            isDisabled: viewModel.isLoading,
            isLoading: viewModel.isLoading,
            onClick: {
                //Task { await viewModel.collectBirthdate(birthdate: date.yyyyMMdd) }
            }
        ) {
            DatePicker("",
                selection: $date,
                in: dateRange,
                displayedComponents: [.date])
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            Button {
                Task { await viewModel.collectBirthdate(birthdate: nil) }
            } label: {
                Text("preferNotToSay")
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.primarySB)
            .fontWeight(.bold)
        }
    }
}

//#Preview("Light") {
//    CollectBirthdateScreen()
//}
//
//#Preview("Dark") {
//    CollectBirthdateScreen()
//        .preferredColorScheme(.dark)
//}
