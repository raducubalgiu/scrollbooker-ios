//
//  CollectUserGenderScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectUserGenderScreen: View {
    var body: some View {
        FormLayout(
            headline: "Alege genul tau",
            subHeadline: "Ne ajuta sa iti oferim servicii relevante pentru tine",
            buttonTitle: "Pasul urmator"
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectUserGenderScreen()
}

#Preview("Dark") {
    CollectUserGenderScreen()
        .preferredColorScheme(.dark)
}
