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
            headline: "Valute acceptate pentru plati",
            subHeadline: "Alege in ce valute accepti sa primesti plati din partea clientilor",
            enableBack: true,
            buttonTitle: "Salveaza"
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
