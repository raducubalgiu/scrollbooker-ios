//
//  MySchedulesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MySchedulesScreen: View {
    @State private var selectedOption = ""
    @State private var isExpanded = false
    let options = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00"]
    
    var body: some View {
        FormLayout(
            headline: String(localized: "schedule"),
            subHeadline: String(localized: "scheduleSubheaderDescription"),
            enableBack: true,
            buttonTitle: String(localized: "save")
        ) {
            HStack(alignment: .top) {
                VStack {
                    Text("Luni")
                }
                .padding(.vertical)
                
                SelectView()
                
                SelectView()
            }
        }
    }
}

#Preview("Light") {
    MySchedulesScreen()
}

#Preview("Dark") {
    MySchedulesScreen()
        .preferredColorScheme(.dark)
}
