//
//  MyCurrenciesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyCurrenciesScreen: View {
    @State private var vibrateOnRing = true
    
    var body: some View {
        FormLayout(
            headline: String(localized: "acceptedCurrencies"),
            subHeadline: String(localized: "chooseDesiredCurrencies"),
            enableBack: true,
            buttonTitle: String(localized: "save")
        ) {
            Toggle("Vibrate on Ring", isOn: $vibrateOnRing)
        }
    }
}

#Preview("Light") {
    MyCurrenciesScreen()
}

#Preview("Dark") {
    MyCurrenciesScreen()
        .preferredColorScheme(.dark)
}
