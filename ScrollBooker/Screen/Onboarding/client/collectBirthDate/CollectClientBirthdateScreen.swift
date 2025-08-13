//
//  CollectClientBirthdateScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectClientBirthdateScreen: View {
    @State private var date = Date()
        let dateRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let startComponents = DateComponents(year: 2021, month: 12, day: 15)
            let endComponents = DateComponents(year: 2021, month: 12, day: 30, hour: 23, minute: 59, second: 59)
            return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
        }()
    
    var body: some View {
        FormLayout(
            headline: "Data de nastere",
            subHeadline: "Folosim aceasta informatie doar pentru a-ti personaliza experienta",
            buttonTitle: "Pasul urmator"
        ) {
            DatePicker(
                "",
                selection: $date,
                in: dateRange,
                displayedComponents: [.date])
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            Button {
                
            } label: {
                Text("Prefer sa nu spun")
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.primarySB)
            .fontWeight(.bold)
        }
    }
}

#Preview("Light") {
    CollectClientBirthdateScreen()
}

#Preview("Dark") {
    CollectClientBirthdateScreen()
        .preferredColorScheme(.dark)
}
