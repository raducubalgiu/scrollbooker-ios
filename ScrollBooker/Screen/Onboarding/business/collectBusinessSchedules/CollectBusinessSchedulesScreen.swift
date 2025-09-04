//
//  CollectBusinessSchedulesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import SwiftUI

struct CollectBusinessSchedulesScreen: View {
    var body: some View {
        FormLayout(
            headline: "Schedules",
            subHeadline: "Adauga serviciile pe care le desfasori la locatie",
            buttonTitle: "Pasul urmator",
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectBusinessSchedulesScreen()
}

#Preview("Dark") {
    CollectBusinessSchedulesScreen()
        .preferredColorScheme(.dark)
}
