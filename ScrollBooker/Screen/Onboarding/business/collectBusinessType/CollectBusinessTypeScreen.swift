//
//  CollectBusinessTypeScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectBusinessTypeScreen: View {
    var body: some View {
        FormLayout(
            headline: "Ce business ai?",
            subHeadline: "Alege categoria care descrie cel mai bine activitatea ta",
            buttonTitle: "Pasul urmator",
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectBusinessTypeScreen()
}

#Preview("Dark") {
    CollectBusinessTypeScreen()
        .preferredColorScheme(.dark)
}
