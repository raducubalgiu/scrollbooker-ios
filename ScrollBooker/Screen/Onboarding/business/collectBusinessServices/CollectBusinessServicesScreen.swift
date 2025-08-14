//
//  CollectBusinessServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessServicesScreen: View {
    var body: some View {
        FormLayout(
            headline: "Servicii",
            subHeadline: "Adauga serviciile pe care le desfasori la locatie",
            buttonTitle: "Pasul urmator",
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectBusinessServicesScreen()
}

#Preview("Dark") {
    CollectBusinessServicesScreen()
        .preferredColorScheme(.dark)
}
